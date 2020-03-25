#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "names.h"

extern int yylineno;

nnode add_new_name(nnode *last_end, nnode must_not_be_in, char *name, int line) {
    if(strcmp(name, "")==0) return *last_end;
    if (last_end!=0) must_not_exist(*last_end, name, line);
    must_not_exist(must_not_be_in, name, line);
    //fprintf(stderr, "adding %s at line %d\n", name, line);
    nnode new_name_node;
    new_name_node.line = line;
    new_name_node.predecessor = last_end;
    new_name_node.name = name;
    return new_name_node;
}

void must_not_exist(nnode node, char *name, int line) {
    int exists_in_line = check_exists(node, name); 
    if(exists_in_line != 0) {
        fprintf(stderr, "line %d: %s already declared in line %d!\n", line, name, exists_in_line);
        exit(3);
    }
}

void must_exist(nnode node, char *name, int line) {
    if(check_exists(node, name) == 0) { 
        fprintf(stderr, "line %d: %s not declared!\n", line, name);
        exit(3);
    }
}

int check_exists(nnode node, char *name) {
    if(node.name == 0) return 0;
    if(strcmp(node.name, name)==0) return node.line;
    if(node.predecessor == 0) return 0;
    return check_exists(*node.predecessor, name);
}
