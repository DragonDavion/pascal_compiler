#include "symtabl.h"
#include "parse.tab.h"
#include <stdlib.h>
#include <malloc.h>
#include <string.h>

static int cmp_func(void *str0, void *str1)
{
	return strcmp((char *)str0, (char *)str1);
}

struct symtab_s *symtab_new(struct symtab_s *parent)
{
	struct symtab_s *symtab = NULL
	
	if((symtab = (struct symtab_s *)malloc(sizeof(struct symtab_s))) == NULL) {
		// TODO
	}
	else {
		symtab->parent = parent;
		symtab->param_info_tree = new_rb_tree();
		symtab->const_info_tree = new_rb_tree();
		symtab->type_info_tree = new_rb_tree();
		symtab->var_info_tree = new_rb_tree();
		symtab->routine_info_tree = new_rb_tree();
	}
	
	return symtab;
}

void symtab_insert_const_def(struct symtab_s *symtab, struct const_def_s *const_def)
{
	char *name = const_def->name;
	
	if(check_duplicate(symtab, name))
		yyerror(NULL, "Duplicated const name!");
	else
		insert_into_rb_tree(symtab->const_info_tree, name, cmp_func, const_def);
}

void symtab_insert_type(struct symtab_s *symtab, struct type_s *type)
{
	char *name = type->name;
	
	if(check_duplicate(symtab, name))
		yyerror(NULL, "Duplicated type name!");
	else {
		insert_into_rb_tree(symtab->type_info_tree, name, cmp_func, type);
		switch(type->type) {
			case(TYPE_REF): {
				// TODO
				break;
			}
			case(TYPE_INTEGER): {
				type->width = 8;
				break;
			}
			case(TYPE_BOOL): {
				type->width = 1;
				break;
			}
			case(TYPE_REAL): {
				type->width = 8;
				break;
			}
			case(TYPE_ARRAY): {
				struct type_array_s *type_array = TYPE_ARRAY_S(type);
				struct type_sub_s *type_sub = TYPE_SUB_S(type_array->bound);
				type->width = (type_sub->val_upper - type_sub->val_lower) * type_array->array_type->width;
				break;
			}
			case(TYPE_RECORD): {
				struct field_s *fields = TYPE_RECORD_S(type)->fields, *field_tmp = NULL, *field_save = NULL;
				type->width = 0;
				while(fields != NULL) {
					field_save = fields->prev;
					fields->prev = field_tmp;
					field_tmp = fields;
					fields = field_save;
				}
				
				int offset = 0;
				while(field_tmp != NULL) {
					field_tmp->offset = offset;
					offset += field_tmp->type->width;
					type->width += field_tmp->type->width;
					field_tmp = field_tmp->prev;
				}
				break;
			}
			case(TYPE_ENUM): {
				type->width = 8;
				break;
			}
			case(TYPE_SUB): {
				struct type_sub_s *type_sub = TYPE_SUB_S(type);
				type->width = 8;
				switch(type_sub->lower) {
					case(EXPR_TYPE_INTEGER): {
						type_sub->val_lower = EXPR_INTEGER(type_sub->lower)->val;
						break;
					}
					case(EXPR_TYPE_VAR): {
						struct const_def_s const_def = *search_const_def(symtab, EXPR_VAR(type_sub->lower)->id);
						if(const_def != NULL) {
							type_sub->val_lower = EXPR_INTEGER(const_def->val)->val;
						}
						break;
					}
					default: {
						yyerror(NULL, "Sub type don't match!");
					}
				}
				switch(type_sub->upper) {
					case(EXPR_TYPE_INTEGER): {
						type_sub->val_upper = EXPR_INTEGER(type_sub->upper)->val;
						break;
					}
					case(EXPR_TYPE_VAR): {
						struct const_def_s const_def = *search_const_def(symtab, EXPR_VAR(type_sub->upper)->id);
						if(const_def != NULL) {
							type_sub->val_upper = EXPR_INTEGER(const_def->val)->val;
						}
						break;
					}
					default: {
						yyerror(NULL, "Sub type don't match!");
					}
				}
				type_sub->val_lower *= type_sub->factor_lower;
				type_sub->val_upper *= type_sub->factor_upper;
				break;
			}
		}
	}
}

