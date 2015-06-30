#ifndef STMT_H_
#define STMT_H_

#include "expr.h"

#define STMT_TYPE_ASSIGN 0
#define STMT_TYPE_IF 1
#define STMT_TYPE_REPEAT 2
#define STMT_TYPE_WHILE 3
#define STMT_TYPE_FOR 4
#define STMT_TYPE_CASE 5
#define STMT_TYPE_GOTO 6
#define STMT(x) (((struct stmt_s*)(x)) - 1)
#define STMT_ASSIGN(x) ((struct stmt_assign_s*)(x + 1))
#define STMT_IF(x) ((struct stmt_if_s*)(x + 1))
#define STMT_REPEAT(x) ((struct stmt_repeat_s*)(x + 1))
#define STMT_WHILE(x) ((struct stmt_while_s*)(x + 1))
#define STMT_FOR(x) ((struct stmt_for_s*)(x + 1))
#define STMT_CASE(x) ((struct stmt_case_s*)(x + 1))
#define STMT_GOTO(x) ((struct stmt_goto_s*)(x + 1))

struct stmt_s {
	int type;
	int label;
	struct stmt_s *prev;
};

struct case_expr_s {
	struct expr_s *expr;
	struct stmt_s *stmt;
	struct case_expr_s *prev;
};

struct stmt_assign_s {
	struct expr_s *lval;
	struct expr_s *expr;
};

struct stmt_if_s {
	struct expr_s *cond;
	struct stmt_s *then_stmt;
	struct stmt_s *else_stmt;
};

struct stmt_repeat_s {
	struct expr_s *cond;
	struct stmt_s *stmt;
};

struct stmt_while_s {
	struct expr_s *cond;
	struct stmt_s *stmt;
};

struct stmt_for_s {
	char *id;
	struct expr_s *init, *target;
	int step;
	struct stmt_s *stmt;
};

struct stmt_case_s {
	struct expr_s *expr;
	struct case_expr_s *case_expr;
};

struct stmt_goto_s {
	int target;
};

struct stmt_s *stmt_push(struct stmt_s*, struct stmt_s*);
struct stmt_s *stmt_label(struct stmt_s*, char*);
struct stmt_s *stmt_new_assign(struct expr_s*, struct expr_s*);
struct stmt_s *stmt_fill_if(struct stmt_s*, struct expr_s*, struct stmt_s*);
struct stmt_s *stmt_new_if(struct stmt_s*);
struct stmt_s *stmt_new_repeat(struct stmt_s*, struct expr_s*);
struct stmt_s *stmt_new_while(struct expr_s*, struct stmt_s*);
struct stmt_s *stmt_fill_for(struct stmt_s*, char*, struct expr_s*, struct expr_s*, struct stmt_s*) ;
struct stmt_s *stmt_new_for(int);
struct stmt_s *stmt_new_case(struct expr_s*, struct case_expr_s*);
struct case_expr_s *case_expr_push(struct case_expr_s*, struct case_expr_s*);
struct case_expr_s *case_expr_new(struct expr_s*, struct stmt_s*);
struct stmt_s *stmt_new_goto(char*);

#endif

