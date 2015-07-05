#include "gen.h"


static void opt_const_expr_op(struct expr_s *expr) {
	struct expr_op_s *expr_op = EXPR_OP(expr);
	if (expr_op->x) expr_op->x = opt_const_expr(expr_op->x);
	if (expr_op->y) expr_op->y = opt_const_expr(expr_op->y);
	switch (expr_op->op) {
		case TOK_PLUS:
			if (expr_op->x->type == EXPR_TYPE_INTEGER && expr_op->y->type == EXPR_TYPE_INTEGER){
				EXPR_INTEGER(expr_op->x)->value += EXPR_INTEGER(expr_op->y)->value;
				return expr_op->x;
			}
			break;
	}
}

struct expr_s *opt_const_expr(struct epxr_s *expr) {
	void *sr;
	int st;
	switch (expr->type) {
		case EXPR_TYPE_VAR:
			sr = search_symtab(symtab_current, EXPR_VAR(expr)->id, &st);
			if (st == SYMTAB_SEARCH_RESULT_CONST) {
				return ((const_def_s*)sr)->value;
			}
			break;
		case EXPR_TYPE_OP: return opt_const_expr_op(expr); break;
	}
}

static void gen_expr_cond(char *cond) {
	puts("cmpq %rdx, %rax");
	printf("set%d %al", cond);
	puts("movzbq %al, %rax");
}

static void gen_expr_op(struct expr_s *expr) {
	struct expr_op_s *expr_op = EXPR_OP(expr);
	if (!expr_op->x) {
		gen_expr(expr_op->y);
		if (expr_op->op == TOK_NOT) {
			puts("cmpq $0, %rax");
			puts("setne %al");
			puts("movzbq %al, %rax");
		} else {
			puts("negq %rax");
		}
	} else {
		gen_expr(expr_op->y);
		puts("pushq %rax");
		gen_expr(expr_op->x);
		if (expr_op->op != TOK_COMMA) puts("popq %rdx");
		switch (expr_op->op) {
			case TOK_GE: gen_expr_cond("ge"); break;
			case TOK_GT: gen_expr_cond("gt"); break;
			case TOK_LE: gen_expr_cond("le"); break;
			case TOK_LT: gen_expr_cond("lt"); break;
			case TOK_EQUAL: gen_expr_cond("e"); break;
			case TOK_UNEQUAL: gen_expr_cond("ne"); break;
			case TOK_PLUS: puts("addq %rdx, %rax"); break;
			case TOK_MINUS: puts("subq %rdx, %rax"); break;
			case TOK_OR: puts("orq %rdx, %rax"); break;
			case TOK_MUL: puts("imulq %rdx, %rax"); break;
			case TOK_DIV: puts("cqto"); puts("idivq %rdx, %rax"); break;
			case TOK_MOD: puts("cqto"); puts("idivq %rdx, %rax"); break;
			case TOK_AND: puts("andq %rdx, %rax"); break;
			case TOK_RDIV: /**/ break;
		}
	}
}

static void gen_expr_var(struct expr_s *expr) {
	struct expr_var_s *expr_var = EXPR_VAR(expr);
	if (expr_var->var->is_global) {
		printf("movq global_var+%d(%rip), %rax\n", expr_var->var->ofs);
	} else {
		printf("movq %d(%rbp), %rax\n", expr_var->var->ofs + 8);
	}
};

static void gen_expr_funct(struct expr_s *expr) {
	struct expr_funct_s *expr_funct = EXPR_FUNCT(expr);
	if (expr_funct->args) gen_expr_op(expr_funct->args);
	printf("call %s\n", expr_funct->id);
};

static void gen_expr_array(struct expr_s *expr) {
	struct expr_array_s *expr_array = EXPR_ARRAY(expr);
	gen_expr(expr_array->x);
	// printf("imulq $%d, %rax\n", expr-array->var->base->width);
	if (expr_array->var->is_global) {
		printf("movq global_var+%d(,%rax,8), %rax\n", expr_array->var->ofs);
	} else {
		printf("addq $%d, %rax", expr_array->var->ofs);
		printf("movq %d(%rbp,%rax,8), %rax\n", expr_array->var->ofs + 8);
	}
};

static void gen_expr_record(struct expr_s *expr) {
	struct expr_record_s *expr_record = EXPR_RECORD(expr);
	int ofs1 = expr_record->var->ofs;
	int ofs2 = expr_record->field->ofs;
	if (expr_record->var->is_global) {
		printf("movq global_var+%d(%rip), %rax\n", ofs1 + ofs2);
	} else {
		printf("movq %d(%rbp), %rax\n", ofs1 + ofs2 + 8);
	}
};

static void gen_expr(struct expr_s *expr) {
	switch (expr->type) {
		case EXPR_TYPE_OP: gen_expr_op(expr); break;
		case EXPR_TYPE_VAR: gen_expr_var(expr); break;
		case EXPR_TYPE_FUNCT: gen_expr_funct(expr); break;
		case EXPR_TYPE_ARRAY: gen_expr_array(expr); break;
		case EXPR_TYPE_RECORD: gen_expr_record(expr); break;
		case EXPR_TYPE_INTEGER: printf("movq $%d, %rax\n", EXPR_INTEGER(expr)->value); break;
		case EXPR_TYPE_REAL: /**/ break;
		case EXPR_TYPE_CHAR: printf("movq $%d, %rax\n", (int)(EXPR_CHAR(expr)->value)); break;
		case EXPR_TYPE_STRING: printf("movq .LC%d, %rax\n", (EXPR_STRING(expr)->sid)); break;
		case EXPR_TYPE_BOOLEAN: printf("movq $%d, %rax\n", (EXPR_BOOLEAN(expr)->value)); break;
	}
}

static void gen_lexpr(struct expr_s *expr) {
	switch (expr->type) {
		case EXPR_TYPE_VAR:
		case EXPR_TYPE_ARRAY:
		case EXPR_TYPE_RECORD:
	}
}


void gen_stmt(struct stmt_s *stmt) {
}
