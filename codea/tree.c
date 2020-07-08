#include "tree.h"
#include <stdlib.h>

struct Tree *new_node(struct Tree *left, struct Tree *right, enum Type type) {
    struct Tree *ret = malloc(sizeof *ret);
    ret->node_type = type;
    ret->left_child = left;
    ret->right_child = right;
    ret->reg = REG_NONE;
    ret->value = 0;
    ret->id = NULL;
    ret->state = NULL;
    return ret;
}

struct Tree *new_const_node(long val) {
    struct Tree *ret = new_node(NULL, NULL, TREE_CONST);
    ret->value = val;
    return ret;
}

struct Tree *new_varusage_node(char *id) {
    struct Tree *ret = new_node(NULL, NULL, TREE_VAR);
    ret->id = id;
    return ret;
}

struct Tree *new_varassign_node(struct Tree *lexpr, struct Tree *expr) {
    struct Tree *ret = new_node(lexpr, expr, TREE_ASSIGN);
	return ret;
}

struct Tree *new_vardeclar_node(char *id, struct Tree *expr) {
    struct Tree *ret = new_node(expr, NULL, TREE_DECL);
    ret->id = id;
    return ret;
}

