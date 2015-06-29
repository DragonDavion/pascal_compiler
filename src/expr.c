#include <stdlib.h>
#include <limits.h>
#include <string.h>
#include <stdio.h>
#include "expr.h"

//#define EXPR_DEBUG

#ifdef EXPR_DEBUG
	extern const char *get_token_name(int);
#endif

struct expr_s *expr_new_integer(char *str) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s\n", str);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_integer_s));
	EXPR_INTEGER(expr)->value = atoi(str);
	return expr;
}

struct expr_s *expr_new_real(char *str) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s\n", str);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_real_s));
	EXPR_REAL(expr)->value = atof(str);
	return expr;
}

struct expr_s *expr_new_char(char *str) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s\n", str);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_char_s));
	EXPR_CHAR(expr)->value = str[1];
	return expr;
}

struct expr_s *expr_new_string(char *str) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s\n", str);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_string_s));
	int len = strlen(str);
	char *inner = malloc(len - 2);
	strncpy(inner, str + 1, len - 2);
	inner[len - 2] = 0;
	EXPR_STRING(expr)->value = inner;
	return expr;
}

struct expr_s *expr_new_sys_con(char *str) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s\n", str);
	#endif
	// TODO
	return NULL;
}

struct expr_s *expr_new_op(int op, struct expr_s *x, struct expr_s *y) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s\n", get_token_name(op));
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_op_s));
	struct expr_op_s *t = EXPR_OP(expr);
	t->op = op;
	t->x = x;
	t->y = y;
	return expr;
}

struct expr_s *expr_new_var(char *id) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s\n", id);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_var_s));
	EXPR_VAR(expr)->id = id;
	return expr;
}

struct expr_s *expr_new_funct(char *id, struct expr_s *args) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s()\n", id);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_funct_s));
	EXPR_FUNCT(expr)->id = id;
	EXPR_FUNCT(expr)->args = args;
	return NULL;
}

struct expr_s *expr_new_array(char *id, struct expr_s *x) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s[]\n", id);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_array_s));
	EXPR_ARRAY(expr)->id = id;
	EXPR_ARRAY(expr)->x = x; 
	return NULL;
}

struct expr_s *expr_new_record(char *id, char *sub_id) {
	#ifdef EXPR_DEBUG
		fprintf(stderr, "expr: %s.%s\n", id, sub_id);
	#endif
	struct expr_s *expr = malloc(sizeof(struct expr_s) + sizeof(struct expr_record_s));
	EXPR_RECORD(expr)->id = id;
	EXPR_RECORD(expr)->sub_id = sub_id;
	return NULL;
}

