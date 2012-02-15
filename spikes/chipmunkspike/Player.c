/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <SDL/SDL.h>  // TODO try to break this dep or isolate

#include <GL/gl.h>  // TODO try to break this dep or isolate

#include <chipmunk/chipmunk.h>
#include "ChipmunkDemo.h"
#include "game.h"


#define PLAYER_VELOCITY 500.0

#define PLAYER_GROUND_ACCEL_TIME 0.1
#define PLAYER_GROUND_ACCEL (PLAYER_VELOCITY/PLAYER_GROUND_ACCEL_TIME)

#define PLAYER_AIR_ACCEL_TIME 0.25
#define PLAYER_AIR_ACCEL (PLAYER_VELOCITY/PLAYER_AIR_ACCEL_TIME)

#define JUMP_HEIGHT 50.0
#define JUMP_BOOST_HEIGHT 55.0
#define FALL_VELOCITY 900.0
#define GRAVITY 2000.0

#define MAX_HEIGHT  6
#define MAX_WIDTH  2

static Color colors[MAX_HEIGHT][MAX_WIDTH];

static cpSpace *space;

static cpBody *playerBody = NULL;
static cpShape *playerShape = NULL;

static cpFloat remainingBoost = 0;
static cpBool grounded = cpFalse;
static cpBool lastJumpState = cpFalse;

static cpShape *delShapeA;
static cpShape *delShapeB;

static OneWayPlatform platformInstance;
static GameEntityData playerData;
static GameEntityData boxData;


static ShapeConfig bulletShapeConf; // TODO used after init, considerations?
static ShapeConfig wallShapeConf;
static ShapeConfig playerShapeConf;
static ShapeConfig boxShapeConf; //TODO used repeatedly during init, considerations?
static ShapeConfig onewayPlatformShapeConf;


SDL_Surface *loadBMP(char *filename) {
    Uint8 *rowhi, *rowlo;
    Uint8 *tmpbuf, tmpch;
    SDL_Surface *image;
    int i, j;

    image = SDL_LoadBMP(filename);
    if (image == NULL) {
        fprintf(stderr, "Unable to load %s: %s\n", filename, SDL_GetError());
        return (NULL);
    }

    /* GL surfaces are upsidedown and RGB, not BGR :-) */
    tmpbuf = (Uint8 *) malloc(image->pitch);
    if (tmpbuf == NULL) {
        fprintf(stderr, "Out of memory\n");
        return (NULL);
    }
    rowhi = (Uint8 *) image->pixels;
    rowlo = rowhi + (image->h * image->pitch) - image->pitch;
    for (i = 0; i < image->h / 2; ++i) {
        for (j = 0; j < image->w; ++j) {
            tmpch = rowhi[j * 3];
            rowhi[j * 3] = rowhi[j * 3 + 2];
            rowhi[j * 3 + 2] = tmpch;
            tmpch = rowlo[j * 3];
            rowlo[j * 3] = rowlo[j * 3 + 2];
            rowlo[j * 3 + 2] = tmpch;
        }
        memcpy(tmpbuf, rowhi, image->pitch);
        memcpy(rowhi, rowlo, image->pitch);
        memcpy(rowlo, tmpbuf, image->pitch);
        rowhi += image->pitch;
        rowlo -= image->pitch;
    }
    free(tmpbuf);
    return (image);
}

// Load Bitmaps And Convert To Textures

void loadGLTexture(GLuint *texture, char *filePath) {
    // Load Texture
    SDL_Surface *image1;

    image1 = loadBMP(filePath);
    if (!image1) {
        SDL_Quit();
        exit(1);
    }

    // Create Texture
    glGenTextures(1, texture);
    glBindTexture(GL_TEXTURE_2D, *texture); // 2d texture (x and y size)

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR); // scale linearly when image bigger than texture
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); // scale linearly when image smalled than texture

    // 2d texture, level of detail 0 (normal), 3 components (red, green, blue), x size from image, y size from image,
    // border 0 (normal), rgb color data, unsigned byte data, and finally the data itself.
    glTexImage2D(GL_TEXTURE_2D, 0, 3, image1->w, image1->h, 0, GL_RGB, GL_UNSIGNED_BYTE, image1->pixels);
};


static cpBool preSolve(cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, a, b);
    OneWayPlatform *platform = (OneWayPlatform *) cpShapeGetUserData(a);

    if (cpvdot(cpArbiterGetNormal(arb, 0), platform->n) < 0) {
        cpArbiterIgnore(arb);
        return cpFalse;
    }

    return cpTrue;
}

static cpBool bulletHitWall(cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, a, b);
    if (a->collision_type == WALL_COLLISION_TYPE) {
        //printf("bullet is A\n");
        //printf("wall is B\n");
    } else {
        //printf("bullet is B\n");
        //printf("wall is A\n");
    }
    //printf("bullet hit wall.\n");
    return cpTrue;
}

static void deleteCollidedShapes(cpSpace *space, void *obj, void *data) {
    cpSpaceRemoveShape(space, delShapeA);
    cpSpaceRemoveShape(space, delShapeB);
}

static cpBool bulletHit(cpArbiter *arb, cpSpace *space, void *ignore) {
    CP_ARBITER_GET_SHAPES(arb, a, b);

    cpSpaceAddPostStepCallback(space, deleteCollidedShapes, NULL, NULL);


    delShapeA = a;
    delShapeB = b;

    printf("bullet hit.\n");
    return cpTrue;
}

static void SelectPlayerGroundNormal(cpBody *body, cpArbiter *arb, cpVect *groundNormal) {
    cpVect n = cpvneg(cpArbiterGetNormal(arb, 0));

    if (n.y > groundNormal->y) {
        (*groundNormal) = n;
    }
}

static void playerUpdateVelocity(cpBody *body, cpVect gravity, cpFloat damping, cpFloat dt) {
    int jumpState = (ChipmunkDemoKeyboard.y > 0.0f);

    // Grab the grounding normal from last frame
    cpVect groundNormal = cpvzero;
    cpBodyEachArbiter(playerBody, (cpBodyArbiterIteratorFunc) SelectPlayerGroundNormal, &groundNormal);

    grounded = (groundNormal.y > 0.0);
    if (groundNormal.y < 0.0f) remainingBoost = 0.0f;

    // Do a normal-ish update
    cpBool boost = (jumpState && remainingBoost > 0.0f);
    cpVect g = (boost ? cpvzero : gravity);
    cpBodyUpdateVelocity(body, g, damping, dt);

    // Target horizontal speed for air/ground control
    cpFloat target_vx = PLAYER_VELOCITY * ChipmunkDemoKeyboard.x;

    // Update the surface velocity and friction
    cpVect surface_v = cpv(target_vx, 0.0);
    playerShape->surface_v = surface_v;
    playerShape->u = (grounded ? PLAYER_GROUND_ACCEL / GRAVITY : 0.0);

    // Apply air control if not grounded
    if (!grounded) {
        // Smoothly accelerate the velocity
        playerBody->v.x = cpflerpconst(playerBody->v.x, target_vx, PLAYER_AIR_ACCEL * dt);
    }

    body->v.y = cpfclamp(body->v.y, -FALL_VELOCITY, INFINITY);
}

static cpBody  *buildStaticBody(cpSpace *space, void *conf) {
    return space->staticBody;
}
static cpBody  *buildDynamicBody(cpSpace *space, void *data) {
    ShapeConfig *conf = (ShapeConfig *)data;
    return cpSpaceAddBody(space, cpBodyNew(conf->mass, conf->moment));
}

static cpShape *buildCircleShape(cpBody *body, void *data) {
    ShapeConfig *conf = (ShapeConfig *)data;
    return cpCircleShapeNew(body, conf->circleRadius, conf->circleCenter);
}
static cpShape *buildSegmentShape(cpBody *body, void *data) {
    ShapeConfig *conf = (ShapeConfig *)data;
    return cpSegmentShapeNew(body, conf->segmentV1, conf->segmentV2, conf->segmentThickness);
}
static cpShape *buildBoxShape(cpBody *body, void *data) {
    ShapeConfig *conf = (ShapeConfig *)data;
    return cpBoxShapeNew(body, conf->boxWidth, conf->boxHeight);
}

static cpShape *buildShapeWithBody(cpSpace *space, ShapeConfig *conf) {
    cpShape *shape = NULL;
    cpBody  *body  = NULL;


    body = conf->buildBodyFunc(space, conf);

    cpBodySetPos(body, conf->bodyPositionCOG);
    cpBodySetVel(body, conf->bodyVelocity);
    if (conf->bodyVelocityFunc) body->velocity_func = conf->bodyVelocityFunc;

    shape = conf->buildShapeFunc(body, conf);

    shape = cpSpaceAddShape(space, shape);
    cpShapeSetElasticity(shape, conf->elasticity);
    cpShapeSetFriction(shape, conf->friction);
    cpShapeSetCollisionType(shape, conf->collisionType);
    cpShapeSetUserData(shape, conf->data);
    cpShapeSetLayers(shape, conf->layerMask);

    if (conf->bindCollisionHandlersFunc) conf->bindCollisionHandlersFunc(space);
    if (conf->finalizeFunc) conf->finalizeFunc(shape, conf);
    return shape;
}
static void bindPlayerCollisionHandlers(cpSpace *space) {
    cpSpaceAddCollisionHandler(space, ONEWAY_COLLISION_TYPE, PLAYER_COLLISION_TYPE, NULL, preSolve, NULL, NULL, NULL);
}
static void bindBulletCollisionHandlers(cpSpace *space) {
    cpSpaceAddCollisionHandler(space, DEFAULT_COLLISION_TYPE, BULLET_COLLISION_TYPE, NULL, bulletHit, NULL, NULL, NULL);
    cpSpaceAddCollisionHandler(space, WALL_COLLISION_TYPE, BULLET_COLLISION_TYPE, NULL, bulletHitWall, NULL, NULL, NULL);
}

static cpShape *buildBullet(cpSpace *space) {
    cpFloat radius = 25.0f;
    bulletShapeConf.mass = 1.0f;
    bulletShapeConf.bodyType  = DYNAMIC_BODY;
    bulletShapeConf.buildBodyFunc = buildDynamicBody;
    bulletShapeConf.shapeType = CIRCLE_SHAPE;
    bulletShapeConf.buildShapeFunc = buildCircleShape;
    bulletShapeConf.collisionType = BULLET_COLLISION_TYPE;
    bulletShapeConf.elasticity = 0.0f;
    bulletShapeConf.friction = 1.0f;
    bulletShapeConf.moment = INFINITY;
    bulletShapeConf.bodyPositionCOG = cpv(0,0);
    bulletShapeConf.bodyVelocity = cpvzero;
    bulletShapeConf.circleRadius   = radius;
    bulletShapeConf.circleCenter   = cpvzero;
    bulletShapeConf.layerMask   = NOT_GRABABLE_MASK;
    bulletShapeConf.bodyVelocityFunc = NULL;
    bulletShapeConf.bindCollisionHandlersFunc = bindBulletCollisionHandlers;
    bulletShapeConf.finalizeFunc = NULL;
    bulletShapeConf.data = NULL;
    return buildShapeWithBody(space, &bulletShapeConf);
}
static cpShape *buildWallShape(cpSpace *space, cpVect v1, cpVect v2) {
    wallShapeConf.bodyType = STATIC_BODY;
    wallShapeConf.buildBodyFunc = buildStaticBody;
    wallShapeConf.shapeType = SEGMENT_SHAPE;
    wallShapeConf.buildShapeFunc = buildSegmentShape;
    wallShapeConf.segmentV1 = v1;
    wallShapeConf.segmentV2 = v2;
    wallShapeConf.segmentThickness = 0.0f;

    wallShapeConf.collisionType = WALL_COLLISION_TYPE;
    wallShapeConf.elasticity = 1.0f;
    wallShapeConf.friction = 1.0f;
    wallShapeConf.data = NULL;
    wallShapeConf.layerMask = NOT_GRABABLE_MASK;
    wallShapeConf.bodyVelocityFunc = NULL;
    wallShapeConf.bindCollisionHandlersFunc = NULL;
    wallShapeConf.finalizeFunc = NULL;

    return buildShapeWithBody(space, &wallShapeConf);
}

static void finalizePlayer(cpShape *shape, void *data) {
    playerBody = cpShapeGetBody(shape);
    playerShape = shape; // TODO these bindings should not be in these methods
}

static cpShape *buildPlayerShape(cpSpace *space, cpVect p) {
    cpFloat radius = 15.0f;
    Color c = {1,1,1,1};
    playerData.c = c;
    loadGLTexture(&playerData.texture, "Data06/NeHe.bmp");

    playerShapeConf.bodyType = DYNAMIC_BODY;
    playerShapeConf.buildBodyFunc = buildDynamicBody;
    playerShapeConf.mass = 3.0f;
    playerShapeConf.elasticity = 0.0f;
    playerShapeConf.friction = 0.0f;
    playerShapeConf.moment = INFINITY;
    playerShapeConf.bodyPositionCOG = p;
    playerShapeConf.bodyVelocity = cpv(0,170);
    playerShapeConf.bodyVelocityFunc = playerUpdateVelocity;
    playerShapeConf.bodyAngle = -1.55f;
    playerShapeConf.collisionType = PLAYER_COLLISION_TYPE;
    playerShapeConf.shapeType = CIRCLE_SHAPE;
    playerShapeConf.buildShapeFunc = buildCircleShape;
    playerShapeConf.data = &playerData;
    playerShapeConf.circleRadius = radius;
    playerShapeConf.circleCenter = cpvzero;
    playerShapeConf.layerMask = NOT_GRABABLE_MASK;
    playerShapeConf.bindCollisionHandlersFunc = bindPlayerCollisionHandlers;
    playerShapeConf.finalizeFunc = finalizePlayer;

    //cpSpaceAddCollisionHandler(space, ONEWAY_COLLISION_TYPE, PLAYER_COLLISION_TYPE, NULL, preSolve, NULL, NULL, NULL);
    return buildShapeWithBody(space, &playerShapeConf);

}

static cpShape *buildBox(cpSpace *space, cpVect pos) {

    loadGLTexture(&boxData.texture, "Data06/NeHe.bmp");


    boxShapeConf.shapeType = BOX_SHAPE;
    boxShapeConf.buildShapeFunc = buildBoxShape;
    boxShapeConf.mass = 4.0f;
    boxShapeConf.moment = INFINITY;
    boxShapeConf.bodyType = DYNAMIC_BODY;
    boxShapeConf.buildBodyFunc = buildDynamicBody;
    boxShapeConf.elasticity = 0.0f;
    boxShapeConf.friction = 0.7f;
    boxShapeConf.data = &boxData;
    boxShapeConf.bodyPositionCOG = pos;
    boxShapeConf.boxWidth  = 50;
    boxShapeConf.boxHeight = 50;
    boxShapeConf.bodyVelocityFunc = NULL;
    boxShapeConf.collisionType = DEFAULT_COLLISION_TYPE;
    boxShapeConf.layerMask = NOT_GRABABLE_MASK;
    boxShapeConf.bindCollisionHandlersFunc = NULL;
    boxShapeConf.finalizeFunc = NULL;
    
    return buildShapeWithBody(space, &boxShapeConf);
}


static cpShape *buildOneWayPlatformShape(cpSpace *space, cpVect v1, cpVect v2) {
    platformInstance.n    = cpv(0, 1); // let objects pass upwards

    onewayPlatformShapeConf.data = &platformInstance;

    onewayPlatformShapeConf.bodyType = STATIC_BODY;
    onewayPlatformShapeConf.buildBodyFunc = buildStaticBody;
    onewayPlatformShapeConf.shapeType = SEGMENT_SHAPE;
    onewayPlatformShapeConf.buildShapeFunc = buildSegmentShape;
    onewayPlatformShapeConf.segmentV1 = v1;
    onewayPlatformShapeConf.segmentV2 = v2;
    onewayPlatformShapeConf.segmentThickness = 10.0f;
    onewayPlatformShapeConf.elasticity = 0.0f;
    onewayPlatformShapeConf.friction = 1.0f;
    onewayPlatformShapeConf.collisionType = ONEWAY_COLLISION_TYPE;
    onewayPlatformShapeConf.layerMask = NOT_GRABABLE_MASK;
    onewayPlatformShapeConf.bindCollisionHandlersFunc = NULL;
    onewayPlatformShapeConf.finalizeFunc = NULL;

    return buildShapeWithBody(space, &onewayPlatformShapeConf);
}

static cpSpace *buildSpace() {
    cpSpace *theSpace;

    theSpace = cpSpaceNew();
    theSpace->iterations = 10;
    theSpace->gravity = cpv(0, -GRAVITY);
    //	space->sleepTimeThreshold = 1000;
    theSpace->enableContactGraph = cpTrue;

    return theSpace;
}


static void update(int ticks) {

    int jumpState = (ChipmunkDemoKeyboard.y > 0.0f);
    { // handle jumping
        // If the jump key was just pressed this frame, jump!
        if (jumpState && !lastJumpState && grounded) {
            cpFloat jump_v = cpfsqrt(2.0 * JUMP_HEIGHT * GRAVITY);
            playerBody->v = cpvadd(playerBody->v, cpv(0.0, jump_v));

            remainingBoost = JUMP_BOOST_HEIGHT / jump_v;
        }
    }

    { // update player body rotation angle by trajectory
        playerBody->a = ChipmunkDemoTrajectory * 0.05;
    }


    if (ChipmunkDemoBulletFired) {
        printf("\nhandle bullet fire in player.c resetting\n");
        printf("playerBody position: (%.4f,%.4f\n", playerBody->p.x, playerBody->p.y);
        printf("playerBody rotation angle: (%.4f)\n", playerBody->a);
        printf("trajectory: %d\n", ChipmunkDemoTrajectory);

        buildBullet(space);
        ChipmunkDemoBulletFired = 0;
    }

    // Step the space
    int steps = 3;
    cpFloat dt = 1.0f / 60.0f / (cpFloat) steps;

    for (int i = 0; i < steps; i++) {
        cpSpaceStep(space, dt);

        remainingBoost -= dt;
        lastJumpState = jumpState;
    }
}

static cpSpace * init(void) {
    delShapeA = NULL;
    delShapeB = NULL;

    space = buildSpace();
    cpShape *shape;

    // Create segments around the edge of the screen.
    shape = buildWallShape(space, cpv(-320, -240), cpv(-320, 240));
    shape = buildWallShape(space, cpv(320, -240), cpv(320, 240));
    shape = buildWallShape(space, cpv(-320, -240), cpv(320, -240));
    shape = buildWallShape(space, cpv(-320, 240), cpv(320, 240));

    // add the one-way platform
    shape = buildOneWayPlatformShape(space, cpv(-160, -100), cpv(160, -100));

    // Set up the player
    shape = buildPlayerShape(space, cpv(0, -200));
    

    // Add some boxes to jump on
    shape = buildBox(space, cpv(100, -200));
    for (int i = 0; i < MAX_HEIGHT; i++) {
        for (int j = 1; j < (MAX_WIDTH + 1); j++) {
            shape = buildBox(space, cpv(100 + j * 60, -200 + i * 60));
        }
    }
    
    return space;
}

static void destroy(void) {
    ChipmunkDemoFreeSpaceChildren(space);
    cpSpaceFree(space);
}

static void drawTrajectory() {
    //    printf("drawing trajectory\n");
    //   printf("playerBody position: (%.4f,%.4f)\n", playerBody->p.x,  playerBody->p.y);
    //   printf("trajectory: %d\n", ChipmunkDemoTrajectory);
}

static void draw(void) {
    ChipmunkDebugDrawShapes(space);
    ChipmunkDebugDrawConstraints(space);
    drawTrajectory();
    ChipmunkDebugDrawCollisionPoints(space);
}

ChipmunkDemo Player = {
    "Platformer Player Controls",
    init,
    update,
    draw,
    destroy,
};
/* ChipmunkDemo Player = {
        "Platformer Player Controls",
        init,
        update,
        ChipmunkDemoDefaultDrawImpl,
        destroy,
};*/

