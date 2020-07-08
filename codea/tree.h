#ifndef __TREE_H__
#define __TREE_H__

#include <stddef.h>
#include "asm.h"

struct Tree {
    int node_type;
    struct Tree *left_child;
    struct Tree *right_child;
    long value;
    enum Register reg;
    char *id;    

    struct burm_state* state;
};

#define NODEPTR_TYPE struct Tree*
#define LEFT_CHILD(p) ((p)->left_child)
#define RIGHT_CHILD(p) ((p)->right_child)
#define PANIC printf
#define STATE_LABEL(p) ((p)->state)
#define OP_LABEL(p) ((p)->node_type)

enum Type {
    TREE_CONST = 1,
    TREE_VAR,
    // binary
    TREE_ADD,
    TREE_MULT,
    TREE_AND,
    TREE_NEQ,
    TREE_LEQ,
    // unary
    TREE_NOT,
    TREE_NEG,
    TREE_MEM,

    TREE_RETURN,
    TREE_EXPR,
    TREE_ASSIGN,
    TREE_DECL
};

struct Tree *new_node(struct Tree *left, struct Tree *right, enum Type type);
struct Tree *new_const_node(long val);
struct Tree *new_varusage_node(char *id);
struct Tree *new_varassign_node(struct Tree *lexpr, struct Tree *expr);
struct Tree *new_vardeclar_node(char *id, struct Tree *expr);

#endif
