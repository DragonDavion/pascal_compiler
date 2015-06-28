%{
#include <string.h>
#include <stdlib.h>
#include "parse.tab.h"
#include "define.h"

#define YY_USER_ACTION update_location(yylloc, yytext);

int yywrap();
static void update_location(YYLTYPE*, char*);

%}

%option case-insensitive
%option bison-locations

%%

"/" { return TOK_DIV; }
".." { return TOK_DOTDOT; }
"." { return TOK_DOT; }
";" { return TOK_SEMI; }
"[" { return TOK_LB; }
"]" { return TOK_RB; }
">=" { return TOK_GE; }
">" { return TOK_GT; }
"<=" { return TOK_LE; }
"<" { return TOK_LT; }
"=" { return TOK_EQUAL; }
"<>" { return TOK_UNEQUAL; }
"+" { return TOK_PLUS; }
"-" { return TOK_MINUS; }
"*" { return TOK_MUL; }
":=" { return TOK_ASSIGN; }
":" { return TOK_COLON; }
"," { return TOK_COMMA; }
"(" { return TOK_LP; }
")" { return TOK_RP; }

DIV { return TOK_DIV; }
MOD { return TOK_MOD; }
AND { return TOK_AND; }
OR { return TOK_OR; }
NOT { return TOK_NOT; }
BEGIN { return TOK_BEGIN; }
END { return TOK_END; }
PROGRAM { return TOK_PROGRAM; }
CONST { return TOK_CONST; }
ARRAY { return TOK_ARRAY; }
OF { return TOK_OF; }
RECORD { return TOK_RECORD; }
VAR { return TOK_VAR; }
READ { return TOK_READ; }
IF { return TOK_IF; }
THEN { return TOK_THEN; }
ELSE { return TOK_ELSE; }
REPEAT { return TOK_REPEAT; }
UNTIL { return TOK_UNTIL; }
WHILE { return TOK_WHILE; }
DO { return TOK_DO; }
FOR { return TOK_FOR; }
TO { return TOK_TO; }
DOWNTO { return TOK_DOWNTO; }
CASE { return TOK_CASE; }
GOTO { return TOK_GOTO; }
TYPE { return TOK_TYPE; }
FUNCTION { return TOK_FUNCTION; }
PROCEDURE { return TOK_PROCEDURE; }

WRITE { yylval->integer = SYS_PROC_WRITE; return TOK_SYS_PROC; }
WRITELN { yylval->integer = SYS_PROC_WRITELN; return TOK_SYS_PROC; }
TRUE { yylval->integer = SYS_CON_TRUE; return TOK_SYS_CON; }
FALSE { yylval->integer = SYS_CON_FALSE; return TOK_SYS_CON; }
MAXINT { yylval->integer = SYS_CON_MAXINT; return TOK_SYS_CON; }
INTEGER { yylval->integer = SYS_TYPE_INTEGER; return TOK_SYS_TYPE; }
REAL { yylval->integer = SYS_TYPE_REAL; return TOK_SYS_TYPE; }
BOOLEAN { yylval->integer = SYS_TYPE_BOOLEAN; return TOK_SYS_TYPE; }
CHAR { yylval->integer = SYS_TYPE_CHAR; return TOK_SYS_TYPE; }
ABS { yylval->integer = SYS_TYPE_ABS; return TOK_SYS_FUNCT; }
CHR { yylval->integer = SYS_TYPE_CHR; return TOK_SYS_FUNCT; }
ODD { yylval->integer = SYS_TYPE_ODD; return TOK_SYS_FUNCT; }
ORD { yylval->integer = SYS_TYPE_ORD; return TOK_SYS_FUNCT; }
PRED { yylval->integer = SYS_TYPE_PRED; return TOK_SYS_FUNCT; }
SQR { yylval->integer = SYS_TYPE_SQR; return TOK_SYS_FUNCT; }
SQRT { yylval->integer = SYS_TYPE_SQRT; return TOK_SYS_FUNCT; }
SUCC { yylval->integer = SYS_TYPE_SUCC; return TOK_SYS_FUNCT; }

[0-9]+ { yylval->integer = atoi(yytext); return TOK_INTEGER; }
[0-9]+\.[0-9]+ { yylval->real = atof(yytext); return TOK_REAL; }
'[^\t\n\r]' { yylval->integer = *yytext; return TOK_CHAR; }
'[^'\n\r]+\' {
	yylval->string = malloc(yyleng - 1); //todo: malloc assert
	strncpy(yylval->string, yytext + 1, yyleng - 2);
	yylval->string[yyleng - 2] = 0;
	return TOK_STRING;
	}
[a-z][0-9a-z_]* { yylval->string = strdup(yytext); return TOK_ID; }

[ \t\n\r]
. { return TOK_UNKNOW_CHAR; }

%%

int yywrap() {
	return 1;
}

static void update_location(YYLTYPE *yylloc, char *yytext) {
	int i;
	yylloc->first_line = yylloc->last_line;
	yylloc->first_column = yylloc->last_column;
	for ( i = 0; yytext[i]; i++ ) {
		if ( yytext[i] == '\n' ) {
			yylloc->last_line++;
			yylloc->last_column = 0;
		} else {
			yylloc->last_column++;
		}
	}
}

