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

struct type_s *type_fill_name(struct type_s *type, char *name)
{
	type->name = name;
	
	return type;
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

struct field_s *field_push(struct field_s *field_stack, struct field_s *new_field);
struct field_s *field_new(struct name_list_s *name_list, struct type_s *type);
struct name_list_s *name_list_push(struct name_list_s *name_list_stack, char *new_name);
struct type_s *type_new_sys(char *name);
struct type_s *type_new_equal(char *name);
struct type_s *type_new_enum(struct name_list_s *name_list);
struct type_s *type_new_sub(struct expr_s *lower, struct expr_s *upper, int factor_lower, int factor_upper);
struct const_def_s *const_def_push(struct const_def_s *const_def_stack, char *name, struct expr_s *value);

