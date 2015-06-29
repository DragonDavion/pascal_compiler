#include <stdio.h>
#include "main.h"
#include "parse.tab.h"
#include "symbol_table.h"

int main() {
	return yyparse();
}

int yywarp() {
	return 1;
}

void yyerror(const YYLTYPE *yylloc, const char *msg) {
	printf("%4d,%4d-%4d,%4d: %s\n", yylloc->first_line, yylloc->first_column, yylloc->last_line, yylloc->last_column, msg);
}

