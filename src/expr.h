#ifndef EXPR_H_
#define EXPR_H_

#include <stdlib.h>

#define EXPR_TYPE_OP 0
#define EXPR_TYPE_VAR 1
#define EXPR_TYPE_FUNCT 2
#define EXPR_TYPE_ARRAY 3
#define EXPR_TYPE_RECORD 4
#define EXPR_TYPE_INTEGER 5
#define EXPR_TYPE_REAL 6
#define EXPR_TYPE_CHAR 7
#define EXPR_TYPE_STRING 8
#define EXPR_TYPE_BOOLEAN 9
#define EXPR(x) (((struct expr_s*)(x)) - 1)
#define EXPR_OP(x) ((struct expr_op_s*)((x) + 1))
#define EXPR_VAR(x) ((struct expr_var_s*)((x) + 1))
#define EXPR_FUNCT(x) ((struct expr_funct_s*)((x) + 1))
#define EXPR_ARRAY(x) ((struct expr_array_s*)((x) + 1))
#define EXPR_RECORD(x) ((struct expr_record_s*)((x) + 1))
#define EXPR_INTEGER(x) ((struct expr_integer_s*)((x) + 1))
#define EXPR_REAL(x) ((struct expr_real_s*)((x) + 1))
#define EXPR_CHAR(x) ((struct expr_char_s*)((x) + 1))
#define EXPR_STRING(x) ((struct expr_string_s*)((x) + 1))
#define EXPR_BOOLEAN(x) ((struct expr_boolean_s*)((x) + 1))

struct dummy_s {};

struct expr_s {
	int type;
};

struct expr_op_s {
	int op;
	struct expr_s *x, *y;
};

struct expr_var_s {
	char *id;
};

struct expr_funct_s {
	char *id;
	struct expr_s *args;
};

struct expr_array_s {
	char *id;
	struct expr_s *x;
};

struct expr_record_s {
	char *id;
	char *sub_id;
};

struct expr_integer_s {
	int value;
};

struct expr_real_s {
	double value;
};

struct expr_char_s {
	char value;
};

struct expr_string_s {
	char *value;
};

struct expr_boolean_s {
	int value;
};

struct expr_s *expr_new_integer(char*);
struct expr_s *expr_new_real(char*);
struct expr_s *expr_new_char(char*);
struct expr_s *expr_new_string(char*);
struct expr_s *expr_new_sys_con(char*);
struct expr_s *expr_new_op(int, struct expr_s*, struct expr_s*);
struct expr_s *expr_new_var(char*);
struct expr_s *expr_new_funct(char*, struct expr_s*);
struct expr_s *expr_new_array(char*, struct expr_s*);
struct expr_s *expr_new_record(char*, char*);

#endif

