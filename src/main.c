#include <stdio.h>
#include "main.h"
#include "parse.tab.h"
#include "symtab.h"
#include "ast.h"

struct routine_s *routine_root;

static void calc_symtab(struct routine_s *root, struct symtab_s *father_symtab) {
	root->symtab = symtab_new(father_symtab);

	struct const_def_s *c = root->const_defs;
	while (c) {
		symtab_insert_const_def(root->symtab, c);
		c = c->prev;
	}

	struct type_s *t = root->types, *t_head = NULL, *t_save = NULL;
	while (t) {
		t_save = t->prev;
		t->prev = t_head;
		t_head = t;
		t = t->save;
	}
	while(t_head) {
		symtab_insert_type(root->symtab, t_head);
		t_head = t_head->prev;
	}

	struct var_s *v = root->variables;
	while (v) {
		symtab_insert_var(root->symtab, v->TODO_name, v->TODO_value);
		v = v->TODO_prev;
	}

	struct routine_s *r = root->sub_routines;
	while (r) {
		calc_symtab(r, root->symtab);
		symtab_insert_routine(root->symtab, r->TODO_name, r->TODO_value);
		r = r->TODO_prev;
	}
	
	if (root->proto) {
		struct param_s *p = root->proto->TODO_params;
		while (p) {
			// TODO
			// struct param_item *i = ;
			// symtab_insert_param();
			p = p->TODO_prev;
		}
	}
}

int main() {
	if (yyparse()) return 0;
	calc_symtab(routine_root, NULL);
}

int yywarp() {
	return 1;
}

void yyerror(const YYLTYPE *yylloc, const char *msg) {
	if(yylloc == NULL) {
		printf("Unknown location error: %s\n", msg);
	}
	else
		printf("%4d,%4d-%4d,%4d: %s\n", yylloc->first_line, yylloc->first_column, yylloc->last_line, yylloc->last_column, msg);
}

