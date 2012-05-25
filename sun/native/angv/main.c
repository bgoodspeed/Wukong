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
                printf("ERROR!! Assert %s failed.  %s:%d\n", #x,  __FILE__, __LINE__ ); \
            }
#endif

typedef GList BTList;
typedef GFunc BTFunc;
typedef GHashFunc BTHashFunc;

typedef gsize btsize;
typedef gpointer btpointer;
typedef gconstpointer btconstpointer;
typedef guint btuint;



btsize bt_list_length(BTList *list) { return g_list_length(list); }
BTList *bt_list_append(BTList *list, btpointer data) { return g_list_append(list, data); }
btpointer bt_list_nth_data(BTList *list, btuint n) { return g_list_nth_data(list, n); }
BTList *bt_list_remove(BTList *list, btpointer data) { return g_list_remove(list, data); }
void bt_list_foreach(BTList *list, BTFunc func, btpointer user_data) { g_list_foreach(list, func, user_data);}

void collect_sum(btpointer data, btpointer user_data) {
    int *sum = (int *)user_data;
    *sum = *sum + *(int *)data;
}

int main()
{
    { // BT List Empty
        BTList *empty_list = NULL;

        ASSERT(bt_list_length(empty_list) == 0);

    }
    { // BT List Insert
        int data1 = 1;
        int data2 = 2;
        BTList *list = NULL;
        list = bt_list_append(list, &data1);
        list = bt_list_append(list, &data2);
        ASSERT(bt_list_length(list) == 2);
        ASSERT(bt_list_nth_data(list, 0) == &data1);
        ASSERT(bt_list_nth_data(list, 1) == &data2);
    }
    { // BT List Removal
        int data1 = 1;
        int data2 = 2;
        BTList *list = NULL;
        list = bt_list_append(list, &data1);
        list = bt_list_append(list, &data2);
        list = bt_list_remove(list, &data1);
        ASSERT(bt_list_nth_data(list, 0) == &data2);
    }
    { // Summing with function
        int data1 = 1;
        int data2 = 2;
        int sum = 0;
        BTList *list = NULL;
        list = bt_list_append(list, &data1);
        list = bt_list_append(list, &data2);
        bt_list_foreach(list, collect_sum, &sum);
        ASSERT(sum == 3);
    }








    printf("Hello world!\n");
    return 0;
}
