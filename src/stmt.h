#ifndef STMT_H_
#define STMT_H_

#include "expr.h"

struct stmt_s {
	int type;
	struct stmt_s *prev;
};

struct case_expr_s {
	struct expr_s *expr;
	struct stmt_s *stmt;
	struct case_expr_s *prev;
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

