#ifndef _SYMBOL_TABLE
#define _SYMBOL_TABLE

#include <stdlib.h>
#include "stack.h"
#include "rb_tree.h"

struct stack_s *symbol_table_stack;

struct symbol_table_s
{
	struct rb_tree_node_s *proc_info_root;
	// TODO
};

void init_symbol_table_stack();
void destroy_symbol_table_stack();
struct symbol_table_s *new_symbol_table();

void add_proc_info(struct symbol_table_s *symbol_table, struct proc_info_s *proc_info);

struct proc_info_s
{
	char *name;
	// TODO
};

struct proc_info_s *new_proc_info(char *name);

#endif /* _SYMBOL_TABLE */

