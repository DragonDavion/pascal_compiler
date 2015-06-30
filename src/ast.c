#include "ast.h"
#include <stdlib.h>
#include <malloc.h>

struct routine_s *routine_fill_body(struct routine_s *routine, struct stmt_s *routine_body)
{
	routine->body = routine_body;
	
	return routine;
}

struct routine_s *routine_new(struct const_def_s *const_defs, struct type_s *types, struct var_s *variables, struct routine_s *sub_routines)
{
	struct routine_s *new_routine = NULL;
	
	if((new_routine = (struct routine_s *)malloc(sizeof(struct routine_s))) == NULL) {
		// TODO
	}
	else {
		new_routine->const_defs = const_defs;
		new_routine->types = types;
		new_routine->variables = variables;
		new_routine->sub_routines = sub_routines;
		new_routine->proto = NULL;
		new_routine->body = NULL;
		new_routine->prev = NULL;
	}
	
	return new_routine;
}

struct routine_s *routine_push(struct routine_s *routine_stack, struct routine_s *new_routine)
{
	new_routine->prev = routine_stack;
	
	return new_routine;
}

struct routine_s *routine_fill_proto(struct routine_s *sub_routine, struct routine_proto_s *proto)
{
	sub_routine->proto = proto;
	
	return sub_routine;
}

struct routine_proto_s *routine_proto_new(char *name, struct param_s *parameters, struct type_s *ret_type)
{
	struct routine_proto_s *new_proto = NULL
	
	if((new_proto = (struct routine_proto_s *)malloc(sizeof(struct routine_proto_s))) == NULL) {
		// TODO
	}
	else {
		new_proto->name = name;
		new_proto->paramters = parameters;
		new_proto->ret_type = ret_type;
	}
	
	return new_proto;
}

struct param_s *param_push(struct param_s *param_stack, struct param_item_s *param_item)
{
	struct param_s *new_param = NULL;
	
	if((new_param = (struct param_s *)malloc(sizeof(struct param_s))) == NULL) {
		// TODO
	}
	else {
		new_param->param_item = param_item;
		new_param->prev = param_stack;
	}
	
	return new_param;
}

struct param_item_s *param_item_new(struct name_list_s *name_list, struct type_s *type, int flag)
{
	struct param_item_s *new_param_item = NULL;
	
	if((new_param_item = (struct param_item_s *)malloc(sizeof(struct param_item_s))) == NULL ) {
		// TODO
	}
	else {
		new_param_item->name_list = name_list;
		new_param_item->type = type;
		new_param_item->falg = flag;
	}
}

struct var_s *var_push(struct var_s *var_stack, struct var_s *new_var)
{
	new_var->prev = var_stack;
	
	return new_var;
}

struct var_s *var_new(struct name_list_s *name_list, struct type_s *type)
{
	struct var_s *new_var = NULL;
	
	if((new_var = (struct var_s *)malloc(sizeof(struct var_s))) == NULL) {
		// TODO
	}
	else {
		new_var->name_list = name_list;
		new_var->type = type;
		new_var->prev = NULL;
	}
	
	return new_var;
}

struct type_s *type_push(struct type_s *type_stack, struct type_s *new_type)
{
	new_type->prev = type_stack;
	
	return new_type;
}

struct type_s *type_new_array(struct type_s *bound, struct type_s *array_type)
{
	struct type_s *new_type = NULL;
	
	if((new_type = (struct type_s *)malloc(sizeof(struct type_s) + sizeof(struct type_array_s))) == NULL) {
		// TODO
	}
	else {
		new_type->type = TYPE_ARRAY;
		new_type->prev = NULL;
		TYPE_ARRAY_S(new_type)->bound = bound;
		TYPE_ARRAY_S(new_type)->array_type = array_type;
	}
	
	return new_type;
}

struct type_s *type_new_record(struct field_s *fields)
{
	struct type_s *new_type = NULL;
	
	if((new_type = (struct type_s *)malloc(sizeof(struct type_s) + sizeof(struct type_record_s))) == NULL) {
		// TODO
	}
	else {
		new_type->type = TYPE_RECORD;
		new_type->prev = NULL;
		TYPE_RECORD_S(new_type)->fields = fields;
	}
	
	return new_type;
}

struct field_s *field_push(struct field_s *field_stack, struct field_s *new_field)
{
	new_field->prev = field_stack;
	
	return new_field;
}

struct field_s *field_new(struct name_list_s *name_list, struct type_s *type)
{
	struct field_s *new_field = NULL;
	
	if((new_field = (struct field_s *)malloc(sizeof(struct field_s))) == NULL) {
		// TODO
	}
	else {
		new_field->name_list = name_list;
		new_field->type = type;
		new_field->prev = NULL;
	}
	
	return new_field;
}

struct name_list_s *name_list_push(struct name_list_s *name_list_stack, char *new_name)
{
	struct name_list_s *new_name_list = NULL;
	
	if((new_name_list = (struct name_list_s *)malloc(sizeof(struct name_list_s))) == NULL) {
		// TODO
	}
	else {
		new_name_list->name = name;
		new_name_list->prev = name_list_stack;
	}
	
	return new_name_list;
}

struct type_s *type_new_sys(char *name)
{
	struct type_s *new_type = NULL;
	
	if((strcmp(name, "INTEGER") == 0) || (strcmp(name, "integer") == 0)) {
		if((new_type = (struct type_s *)malloc(sizeof(struct type_s) + sizeof(struct type_integer_s))) == NULL) {
			// TODO
		}
		else {
			new_type->type = TYPE_INTEGER;
			new_type->prev = NULL;
		}
	}
	else if((strcmp(name, "REAL") == 0) || (strcmp(name, "real") == 0)) {
		if((new_type = (struct type_s *)malloc(sizeof(struct type_s) + sizeof(struct type_real_s))) == NULL) {
			// TODO
		}
		else {
			new_type->type = TYPE_REAL;
			new_type->prev = NULL;
		}
	}
	else {
		// TODO
	}
	
	return new_type;
}

struct type_s *type_new_ref(char *name, struct type_s *type)
{
	struct type_s *new_type = NULL;
	
	if((new_type = (struct type_s *)malloc(sizeof(struct type_s) + sizeof(struct type_ref_s))) == NULL) {
		// TODO
	}
	else {
		new_type->type = TYPE_REF;
		new_type->prev = NULL;
		TYPE_REF_S(new_type)->name = name;
		TYPE_REF_S(new_type)->type = type;
	}
	
	return new_type;
}

struct type_s *type_new_enum(struct name_list_s *name_list)
{
	struct type_s *new_type = NULL;
	
	if((new_type = (struct type_s *)malloc(sizeof(struct type_s) + sizeof(struct type_enum_s))) == NULL) {
		// TODO
	}
	else {
		new_type->type = TYPE_ENUM;
		new_type->prev = NULL;
		TYPE_ENUM_S(new_type)->name_list = name_list;
	}
	
	return new_type;
}

struct type_s *type_new_sub(struct expr_s *lower, struct expr_s *upper, int factor_lower, int factor_upper)
{
	struct type_s *new_type = NULL;
	
	if((new_type = (struct type_s *)malloc(sizeof(struct type_s) + sizeof(struct type_sub_s))) == NULL) {
		// TODO
	}
	else {
		new_type->type = TYPE_SUB;
		new_type->prev = NULL;
		TYPE_SUB_S(new_type)->lower = lower;
		TYPE_SUB_S(new_type)->upper = upper;
		TYPE_SUB_S(new_type)->factor_lower = factor_lower;
		TYPE_SUB_S(new_type)->factor_upper = factor_upper;
	}
	
	return new_type;
}

struct const_def_s *const_def_push(struct const_def_s *const_def_stack, char *name, struct expr_s *value)
{
	struct const_def_s *new_const_def = NULL;
	
	if((new_const_def = (struct const_def_s *)malloc(sizeof(struct const_def_s))) == NULL) {
		// TODO
	}
	else {
		new_const_def->name = name;
		new_const_def->value = value;
		new_const_def->prev = const_def_stack;
	}
	
	return new_const_def;

}

