#include <stdio.h>
#include <stdlib.h>

#define DEBUG

#ifndef DEBUG
    #define ASSERT(x)
#else
    #define ASSERT(x) \
        if (! (x)) \
            { \
                printf("ERROR!! Assert %s failed.  %s:%d\n", #x,  __FILE__, __LINE__ ); \
            }
#endif


int main()
{

    printf("Hello world!\n");
    return 0;
}
