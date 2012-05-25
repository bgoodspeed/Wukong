#include <stdio.h>
#include <stdlib.h>


#include <glib.h>

#define DEBUG

#ifndef DEBUG
    #define ASSERT(x)
#else
    #define ASSERT(x) \
        if (! (x)) \
            { \
                printf("Failed assert on line %d in file %s: (%s)\n", __LINE__, __FILE__, #x); \
            }
#endif


int main()
{
    printf("Hello world!\n");

    GList *empty_list = NULL;

    ASSERT(g_list_length(empty_list) == 0);

    return 0;
}
