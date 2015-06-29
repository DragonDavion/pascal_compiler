%{
#include <string.h>
#include <stdlib.h>
#include "parse.tab.h"
#include "lex.yy.h"

#define YY_USER_ACTION \
	yylloc->first_line = yylloc->last_line;\
	yylloc->first_column = yylloc->last_column;\
	yylloc->last_column += yyleng;\
	yylval->str = strndup(yytext, yyleng);

int yywrap();
static void update_location(YYLTYPE*, char*);

%}

%option case-insensitive
%option bison-locations

%%

\{[^\}]*\} // eat comment
\/\/[^\n\r]*\n // eat comment
[ \t] // eat space
[\n\r] { yylloc->last_column = 0; yylloc->last_line++; }

".." { return TOK_DOTDOT; }
":=" { return TOK_ASSIGN; }
"<=" { return TOK_LE; }
">=" { return TOK_GE; }
"<>" { return TOK_UNEQUAL; }
"*" { return TOK_MUL; }
"(" { return TOK_LP; }
")" { return TOK_RP; }
"-" { return TOK_MINUS; }
"+" { return TOK_PLUS; }
"=" { return TOK_EQUAL; }
"[" { return TOK_LB; }
"]" { return TOK_RB; }
";" { return TOK_SEMI; }
":" { return TOK_COLON; }
"," { return TOK_COMMA; }
"<" { return TOK_LT; }
"." { return TOK_DOT; }
">" { return TOK_GT; }
"/" { return TOK_RDIV; }

ABS { return TOK_SYS_FUNCT; }
AND { return TOK_AND; }
ARRAY { return TOK_ARRAY; }
BEGIN { return TOK_BEGIN; }
BOOLEAN { return TOK_SYS_TYPE; }
CASE { return TOK_CASE; }
CHAR { return TOK_SYS_TYPE; }
CHR { return TOK_SYS_FUNCT; }
CONST { return TOK_CONST; }
DIV { return TOK_DIV; }
DOWNTO { return TOK_DOWNTO; }
DO { return TOK_DO; }
ELSE { return TOK_ELSE; }
END { return TOK_END; }
FALSE { return TOK_SYS_CON; }
FOR { return TOK_FOR; }
FUNCTION { return TOK_FUNCTION; }
GOTO { return TOK_GOTO; }
IF { return TOK_IF; }
INTEGER { return TOK_SYS_TYPE; }
MAXINT { return TOK_SYS_CON; }
MOD { return TOK_MOD; }
NOT { return TOK_NOT; }
ODD { return TOK_SYS_FUNCT; }
OF { return TOK_OF; }
ORD { return TOK_SYS_FUNCT; }
OR { return TOK_OR; }
PRED { return TOK_SYS_FUNCT; }
PROCEDURE { return TOK_PROCEDURE; }
PROGRAM { return TOK_PROGRAM; }
READ { return TOK_READ; }
REAL { return TOK_SYS_TYPE; }
RECORD { return TOK_RECORD; }
REPEAT { return TOK_REPEAT; }
SQRT { return TOK_SYS_FUNCT; }
SQR { return TOK_SYS_FUNCT; }
SUCC { return TOK_SYS_FUNCT; }
THEN { return TOK_THEN; }
TO { return TOK_TO; }
UNTIL { return TOK_UNTIL; }
VAR { return TOK_VAR; }
WHILE { return TOK_WHILE; }
WRITE { return TOK_SYS_PROC; }
WRITELN { return TOK_SYS_PROC; }
TRUE { return TOK_SYS_CON; }
TYPE { return TOK_TYPE; }

[0-9]+ { return TOK_INTEGER; }
[0-9]+\.[0-9]+ { return TOK_REAL; }
'[^\t\n\r]' { return TOK_CHAR; }
'[^'\n\r]+\' { return TOK_STRING; }
[a-z][0-9a-z_]* { return TOK_ID; }

. { return TOK_UNKNOW_CHAR; }

%%

int yywrap() {
	return 1;
}

static void update_location(YYLTYPE *yylloc, char *yytext) {
	int i;
	for ( i = 0; yytext[i]; i++ ) {
		if ( yytext[i] == '\n' ) {
			yylloc->last_line++;
			yylloc->last_column = 0;
		} else {
			yylloc->last_column++;
		}
	}
}

