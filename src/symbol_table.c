#include "symbol_table.h"
#include <stdlib.h>
#include <malloc.h>
#include <string.h>

struct stack_s *symbol_table_stack = NULL;

void init_symbol_table_stack()
{
	symbol_table_stack = new_stack();
	
	return;
}

void destroy_symbol_table_stack()
{
	destroy_stack(symbol_table_stack);
	
	return;
}

struct symbol_table_s *new_symbol_table()
{
	struct symbol_table_s *tmp = NULL;
	
	if((tmp = (struct symbol_table_s *)malloc(sizeof(struct symbol_table))) == NULL) {
		// TODO
	} else {
		proc_info_root = new_rb_tree();
	}
	
	return tmp;
}

// proc_info
struct proc_info *new_proc_info(char *name)
{
	struct proc_info_s *tmp = NULL;
	
	if((tmp = (struct proc_info_s *)malloc(sizeof(struct proc_info))) == NULL) {
		// TODO
	} else {
		tmp->name = name;
	}
	
	return tmp;
}

int cmp_func(void *value_ptr0, void *value_ptr1)
{
	return strcmp((char *)value_ptr0,(char *)value_ptr1);
}

void add_proc_info(struct symbol_table_s *symbol_table, struct proc_info_s *proc_info)
{
	insert_into_rb_tree(symbol_table->proc_info_root, proc_info->name, cmp_func, proc_info);
}

