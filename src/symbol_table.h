#ifndef _SYMBOL_TABLE
#define _SYMBOL_TABLE

#include <stdlib.h>
#include "rb_tree.h"

struct symbol_table_s
{
	struct rb_tree_s *proc_info_tree;
	// TODO
};

struct proc_info_s
{
	char *name;
	// TODO
};

struct const_info_s
{
	int type;
	union value
	{
		int int_value;
		double real_value;
		int string_value_id;
	}
}

void init_symbol_table_stack();
void destroy_symbol_table_stack();
void add_proc_info(struct symbol_table_s *symbol_table, struct proc_info_s *proc_info);
struct symbol_table_s *new_symbol_table();
struct proc_info_s *new_proc_info(char *name);

#endif /* _SYMBOL_TABLE */

