#ifndef NAMES_H_
#define NAMES_H_

typedef struct name_node {
    int line;
	char *name;
	struct name_node *predecessor;
} nnode;

nnode add_new_name(nnode*, nnode, char*, int);
void must_not_exist(nnode, char*, int);
void must_exist(nnode, char*, int);
int check_exists(nnode, char*);

#endif
