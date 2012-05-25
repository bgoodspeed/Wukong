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
typedef GHFunc BTHFunc;
typedef GEqualFunc BTEqualFunc;
typedef GHashTable BTHashTable;

typedef gsize btsize;
typedef gpointer btpointer;
typedef gboolean btboolean;
typedef gconstpointer btconstpointer;
typedef guint btuint;



btsize bt_list_length(BTList *list) { return g_list_length(list); }
BTList *bt_list_append(BTList *list, btpointer data) { return g_list_append(list, data); }
btpointer bt_list_nth_data(BTList *list, btuint n) { return g_list_nth_data(list, n); }
BTList *bt_list_remove(BTList *list, btpointer data) { return g_list_remove(list, data); }
void bt_list_foreach(BTList *list, BTFunc func, btpointer user_data) { g_list_foreach(list, func, user_data);}

BTHashTable *bt_hash_table_new(BTHashFunc hash_func, BTEqualFunc key_equal_func) { return g_hash_table_new(hash_func, key_equal_func);}
btuint bt_hash_table_size(BTHashTable *table) { return g_hash_table_size(table); }
void bt_hash_table_insert(BTHashTable *table, btpointer key, btpointer value) { g_hash_table_insert(table, key, value);}
btpointer bt_hash_table_lookup(BTHashTable *table, btpointer key) { return g_hash_table_lookup(table, key);}
btboolean bt_hash_table_remove(BTHashTable *table, btpointer key) { return g_hash_table_remove(table, key);}
void bt_hash_table_foreach(BTHashTable *table, BTHFunc func, btpointer user_data) { g_hash_table_foreach(table, func, user_data);}
btuint bt_int_hash(btconstpointer v) { return g_int_hash(v); }
btboolean bt_int_equal(btconstpointer v1, btconstpointer v2) { return g_int_equal(v1,v2); }


void sample_collect_sum(btpointer data, btpointer user_data) {
    int *sum = (int *)user_data;
    *sum = *sum + *(int *)data;
}
void sample_collect_key_sum(btpointer key, btpointer value, btpointer user_data) {
    int *sum = (int *)user_data;
    *sum = *sum + *(int *)key;
}
void sample_collect_value_sum(btpointer key, btpointer value, btpointer user_data) {
    int *sum = (int *)user_data;
    *sum = *sum + *(int *)value;
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
        bt_list_foreach(list, sample_collect_sum, &sum);
        ASSERT(sum == 3);
    }


    { // BT Hash
        BTHashTable *empty_int_table = bt_hash_table_new(bt_int_hash, bt_int_equal);
        ASSERT(empty_int_table != NULL);
        ASSERT(bt_hash_table_size(empty_int_table) == 0);
    }
    { // BT Hash Insertion
            BTHashTable *int_table = bt_hash_table_new(bt_int_hash, bt_int_equal);
        int key1 = 42;
        int value1 = 69;

        int key2 = 75;
        int value2 = 99;
        bt_hash_table_insert(int_table, &key1, & value1);
        bt_hash_table_insert(int_table, &key2, & value2);

        ASSERT(bt_hash_table_size(int_table) == 2);

        int key1_dupe = 42;
        int bad_key = 8;
        ASSERT(*(int *)bt_hash_table_lookup(int_table, &key1) == 69);
        ASSERT(*(int *)bt_hash_table_lookup(int_table, &key1_dupe) == 69);
        ASSERT(bt_hash_table_lookup(int_table, &bad_key) == NULL);
    }
    { // BT Hash Removal
            BTHashTable *int_table = bt_hash_table_new(bt_int_hash, bt_int_equal);
        int key1 = 42;
        int value1 = 69;

        int key2 = 75;
        int value2 = 99;
        bt_hash_table_insert(int_table, &key1, & value1);
        bt_hash_table_insert(int_table, &key2, & value2);

        bt_hash_table_remove(int_table, &key1);
        ASSERT(bt_hash_table_lookup(int_table, &key1) == NULL);
    }

    {   // BT Hash Foreach
        BTHashTable *int_table = bt_hash_table_new(bt_int_hash, bt_int_equal);
        int key1 = 42;
        int value1 = 69;

        int key2 = 75;
        int value2 = 99;
        bt_hash_table_insert(int_table, &key1, & value1);
        bt_hash_table_insert(int_table, &key2, & value2);

        int key_sum = 0;
        int value_sum = 0;

        bt_hash_table_foreach(int_table, sample_collect_key_sum, &key_sum);
        bt_hash_table_foreach(int_table, sample_collect_value_sum, &value_sum);
        ASSERT(key_sum == 117);
        ASSERT(value_sum == 168);

    }


    printf("Hello world!\n");
    return 0;
}
