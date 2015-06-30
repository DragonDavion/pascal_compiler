#ifndef AST_H_
#define AST_H_

struct routine_s
{
	struct const_def_s *const_defs;
	struct type_s *types;
	struct var_s *variables;
	struct routine_s *sub_routines, *prev;
	struct routine_proto_s *proto;
	struct stmt_s *body;
};

struct routine_proto_s
{
	char *name;
	struct param_s *parameters;
	struct type_s *ret_type;
};

struct param_s
{
	struct param_item_s *param_item;
	struct param_s *prev;
};

struct param_item_s
{
	struct name_list_s *name_list;
	struct type_s *type;
	int flag;
};

struct var_s
{
	struct name_list_s *name_list;
	struct type_s *type;
	struct var_s *prev;
};

#define TYPE_UNKNOWN		0
#define TYPE_INTEGER		1
#define TYPE_BOOL			2
#define TYPE_REAL			3
#define TYPE_ARRAY			4
#define TYPE_RECORD			5
#define TYPE_ENUM			6
#define TYPE_SUB			7

#define TYPE_S(node)			(((struct type_s *)(node)) - 1)
#define TYPE_INTEGER_S(node)	((struct type_integer_s *)((node) + 1))
#define TYPE_BOOL_S(node)		((struct type_bool_s *)((node) + 1))
#define TYPE_REAL_S(node)		((struct type_real_s *)((node) + 1))
#define TYPE_ARRAY_S(node)		((struct type_array_s *)((node) + 1))
#define TYPE_RECORD_S(node)		((struct type_record_s *)((node) + 1))
#define TYPE_ENUM_S(node)		((struct type_enum_s *)((node) + 1))
#define TYPE_SUB_S(node)		((struct type_sub_s *)((node) + 1))

struct type_s
{
	char *name;
	int type;
	struct type_s *prev;
};

struct type_integer_s {};
struct type_bool_s {};
struct type_real_s {};

struct type_array_s
{
	struct type_s *bound, *array_type;
};

struct type_record_s
{
	struct field_s *fields;
};

struct type_enum_s
{
	struct name_list_s *name_list;
};

struct type_sub_s
{
	struct expr_s *lower, *upper;
};

struct field_s
{
	struct name_list_s *name_list;
	struct field_s *prev;
};

struct name_list_s
{
	char *name;
	struct name_list_s *prev;
};

struct const_def_s
{
	char *name;
	struct expr_s *value;
	struct const_def_s *prev;
};

struct routine_s *routine_fill_body(struct routine_s *routine, struct stmt_s *routine_body);
struct routine_s *routine_new(struct const_def_s *const_defs, struct type_s *types, struct var_s *variables, struct routine_s *sub_routines);
struct routine_s *routine_push(struct routine_s *routine_stack, struct routine_s *new_routine);
struct routine_s *routine_fill_proto(struct routine_s *sub_routine, struct routine_proto_s *proto);
struct routine_proto_s *routine_proto_new(char *name, struct param_s *parameters, struct type_s *ret_type);
struct param_s *param_push(struct param_s *param_stack, struct param_item_s *param_item);
struct param_item_s *param_item_new(struct name_list_s *name_list, struct type_s *type, int flag);
struct var_s *var_push(struct var_s *var_stack, struct var_s *new_var);
struct var_s *var_new(struct name_list_s *name_list, struct type_s *type);
struct type_s *type_push(struct type_s *type_stack, struct type_s *new_type);
struct type_s *type_fill_name(struct type_s *type, char *name);
struct type_s *type_new_array(struct type_s *bound, struct type_s *array_type);
struct type_s *type_new_record(struct field_s *fields);
struct field_s *field_push(struct field_s *field_stack, struct field_s *new_field);
struct field_s *field_new(struct name_list_s *name_list, struct type_s *type);
struct name_list_s *name_list_push(struct name_list_s *name_list_stack, char *new_name);
struct type_s *type_new_sys(char *name);
struct type_s *type_new_equal(char *name);
struct type_s *type_new_enum(struct name_list_s *name_list);
struct type_s *type_new_sub(struct expr_s *lower, struct expr_s *upper, int factor_lower, int factor_upper);
struct const_def_s *const_def_push(struct const_def_s *const_def_stack, char *name, struct expr_s *value);

#endif /* AST_H_ */

