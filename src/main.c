#include <stdio.h>
#include "main.h"
#include "parse.tab.h"
#include "symbol_table.h"
#include "ast.h"

struct routine_s *routine_root;

static calc_symtab(struct routine_s *root, struct symtab_s *father_symtab) {
	root->symtab = symtab_new(father_symtab);

	if (root->proto) {
		struct param_s *p = root->proto->parameters;
		while (p) {
			struct name_list_s *n = p->param_item->name_list;
			while (n) {
				symtab_insert_param(root->symtab, n->name, p->param_item->type, p->param_item->flag);
				n = n->prev;
			}
			p = p->prev;
		}
	}

	struct const_def *c = root->const_defs;
	while (c) {
		symtab_insert_const_def(root->symtab, c->name, c->value);
		c = c->prev;
	}

	struct type_s *t = root->types;
	while (t) {
		symtab_insert_type(root->symtab, TYPE_REF(t)->name, TYPE_REF(t)->type);
		t = t->prev;
	}

	struct var_s *v = root->variables;
	while (v) {
		struct name_list *n = v->name_list;
		while (n) {
			symtab_insert_var(root->symtab, n->name, v->type);
			n = n->prev;
		}
		v = v->prev;
	}

	struct routine_s *r = root->sub_routines;
	while (r) {
		calc_symtab(r, root->symtab);
		symtab_insert_routine(root->symtab, r->proto->name, r);
		r = r->prev;
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
	printf("%4d,%4d-%4d,%4d: %s\n", yylloc->first_line, yylloc->first_column, yylloc->last_line, yylloc->last_column, msg);
}

