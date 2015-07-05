#ifndef SYMTAB_H_
#define SYMTAB_H_

#include <stdlib.h>
#include "rb_tree.h"
#include "ast.h"
#include "expr.h"

struct symtab_s
{
	struct symtab_s *parent;
	struct rb_tree_s *param_info_tree;
	struct rb_tree_s *cosnt_info_tree;
	struct rb_tree_s *type_info_tree;
	struct rb_tree_s *var_info_tree;
	struct rb_tree_s *routine_info_tree;
};

struct symtab_s *symtab_new(struct symtab_s *parent);
void symtab_insert_param(struct symtab_s *symtab, struct param_item_s *param_items);
void symtab_insert_const(struct symtab_s *symtab, struct const_def_s *const_defs);
void symtab_insert_type(struct symtab_s *symtab, struct type_s *types);
struct field_s *get_field(struct type_s *type, char *field_name);
void symtab_insert_var(struct symtab_s *symtab, struct var_s *variables);
void symtab_insert_routine(struct symtab_s *symtab, struct routine_s *routines);

#endif /* SYMTAB_H_ */

