#ifndef NAMES_H_
#define NAMES_H_

typedef struct name_node {
    unsigned long line;
	char *name;
	struct name_node *predecessor;
} nnode;

nnode add_new_name(nnode*, nnode, char*, unsigned long);
void must_not_exist(nnode, char*, unsigned long);
void must_exist(nnode, char*, unsigned long);
int check_exists(nnode, char*);

#endif
