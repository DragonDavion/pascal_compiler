%{
#include <stdio.h>
#include <stdlib.h>
#include "main.h"
int yylex(YYSTYPE*, YYLTYPE*);
%}

%code requires {
}

%locations
%token-table
%define api.pure full
%define parse.lac full
%define parse.error verbose

