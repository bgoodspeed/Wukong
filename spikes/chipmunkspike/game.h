/* 
 * File:   game.h
 * Author: bg
 *
 * Created on January 22, 2012, 7:20 PM
 */

#ifndef _GAME_H
#define	_GAME_H


typedef struct _GameEntityData {
    cpVect n;
    Color  c;
    GLuint texture;
}GameEntityData;

typedef GameEntityData OneWayPlatform;



typedef void (*BindCollisionHandlersFunc)(cpSpace *space);
typedef void (*FinalizeShapeFunc)(cpShape *shape, void *conf);
typedef cpBody *(*BuildBodyFunc)(cpSpace *space, void *conf);
typedef cpShape *(*BuildShapeFunc)(cpBody *body, void *conf);


typedef enum _CollisionType {DEFAULT_COLLISION_TYPE, ONEWAY_COLLISION_TYPE, PLAYER_COLLISION_TYPE, BULLET_COLLISION_TYPE, WALL_COLLISION_TYPE} CollisionType;
typedef enum _ShapeType {CIRCLE_SHAPE,BOX_SHAPE, SEGMENT_SHAPE} ShapeType;
typedef enum _BodyType {STATIC_BODY, DYNAMIC_BODY} BodyType;

typedef struct _shapeConfig {
    CollisionType   collisionType;
    cpFloat         elasticity;
    cpFloat         friction;
    cpDataPointer   data;
    cpLayers        layerMask;
    ShapeType       shapeType;
    BodyType        bodyType;
    BuildBodyFunc   buildBodyFunc;
    BuildShapeFunc   buildShapeFunc;
    cpFloat         mass;
    cpFloat         moment;
    cpVect          bodyPositionCOG;
    cpVect          bodyVelocity;
    cpFloat         bodyAngle;
    cpBodyVelocityFunc          bodyVelocityFunc;


    BindCollisionHandlersFunc bindCollisionHandlersFunc;
    // circle stuff
    cpFloat         circleRadius;
    cpVect          circleCenter;
    // end circle stuff

    // box stuff
    cpFloat         boxWidth;
    cpFloat         boxHeight;
    // end box stuff
    // segment stuff
    cpVect          segmentV1;
    cpVect          segmentV2;
    cpFloat         segmentThickness;
    // end segment stuff

    FinalizeShapeFunc finalizeFunc;
} ShapeConfig;


#endif	/* _GAME_H */

