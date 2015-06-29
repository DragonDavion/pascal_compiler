%{
#include <stdio.h>
#include "main.h"
#include "symbol_table.h"
#include "stack.h"

int yylex(YYSTYPE*, YYLTYPE*);
%}

%locations
%define api.pure full
%define parse.lac full
%define parse.error verbose

%union {
	int integer;
	double real;
	char *string;
}

%token TOK_DOTDOT TOK_COLON TOK_COMMA TOK_DOT TOK_SEMI TOK_LB TOK_RB TOK_LP TOK_RP
%token TOK_ASSIGN TOK_EQUAL TOK_UNEQUAL TOK_GE TOK_GT TOK_LE TOK_LT 
%token TOK_PLUS TOK_MINUS TOK_MUL TOK_DIV TOK_MOD TOK_AND TOK_OR TOK_NOT

%token TOK_PROGRAM TOK_CONST TOK_FUNCTION TOK_PROCEDURE TOK_IF TOK_THEN TOK_ELSE
%token TOK_TYPE TOK_ARRAY TOK_OF TOK_RECORD TOK_VAR TOK_READ TOK_BEGIN TOK_END
%token TOK_REPEAT TOK_UNTIL TOK_WHILE TOK_DO TOK_FOR TOK_TO TOK_DOWNTO TOK_CASE TOK_GOTO

%token<string> TOK_ID TOK_STRING
%token<integer> TOK_INTEGER TOK_CHAR
%token<real> TOK_REAL
%token<integer> TOK_SYS_CON TOK_SYS_TYPE TOK_SYS_PROC TOK_SYS_FUNCT

%token TOK_UNKNOW_CHAR

%%

program: program_head routine TOK_DOT {
	destroy_symbol_table_stack();
};

program_head: TOK_PROGRAM TOK_ID TOK_SEMI {
	struct symbol_table_s *symbol_table = symbol_table();
	init_symbol_table_stack();
	push(symbol_table_stack, symbol_table);
	struct proc_info_s *proc_info = new_proc_info($2);
	add_proc_info(symbol_table, proc_info);
}| error;

routine: routine_head routine_body {
};

sub_routine: routine_head routine_body {
};

routine_head: label_part const_part type_part var_part routine_part {
	printf("routine_head end\n");
};

label_part: /*empty*/ {
};

const_part: TOK_CONST const_expr_list {
	printf("const_part end\n");
}| /*empty*/ {
};

const_expr_list: const_expr_list TOK_ID TOK_EQUAL const_value TOK_SEMI {
	printf("const: %s\n", $2);
}| TOK_ID TOK_EQUAL const_value TOK_SEMI {
	printf("const: %s\n", $1);
}| const_expr_list error {
}| error {
};

const_value: TOK_INTEGER {
}| TOK_REAL {
}| TOK_CHAR {
}| TOK_STRING {
}| TOK_SYS_CON {
};

type_part: TOK_TYPE type_decl_list {
	printf("type_part end\n");
}| /*empty*/ {
};

type_decl_list: type_decl_list type_definition {
}| type_definition {
}| type_decl_list error {
}| error {
};

type_definition: TOK_ID TOK_EQUAL type_decl TOK_SEMI {
	printf("type definition: %s\n", $1);
};

type_decl: simple_type_decl {
}| array_type_decl {
}| record_type_decl {
};

array_type_decl: TOK_ARRAY TOK_LB simple_type_decl TOK_RB TOK_OF type_decl {
};

record_type_decl: TOK_RECORD field_decl_list TOK_END {
};

field_decl_list: field_decl_list field_decl {
}| field_decl {
};

field_decl: name_list TOK_COLON type_decl TOK_SEMI {
};

name_list: name_list TOK_COMMA TOK_ID {
}| TOK_ID {
};

simple_type_decl: TOK_SYS_TYPE {
}| TOK_ID {
}| TOK_LP name_list TOK_RP {
}| const_value TOK_DOTDOT const_value {
}| TOK_MINUS const_value TOK_DOTDOT const_value {
}| TOK_MINUS const_value TOK_DOTDOT TOK_MINUS const_value {
}| TOK_ID TOK_DOTDOT TOK_ID {
};

var_part: TOK_VAR var_decl_list {
	printf("var_part end\n");
}| /*empty*/ {
};

var_decl_list: var_decl_list var_decl {
}| var_decl {
}| var_decl_list error {
}| error {
};

var_decl: name_list TOK_COLON type_decl TOK_SEMI {
	printf("var_decl end\n");
};

routine_part: routine_part function_decl {
}| routine_part procedure_decl {
}| function_decl {
}| procedure_decl {
}| /*empty*/ {
};

function_decl: function_head TOK_SEMI sub_routine TOK_SEMI {
};

function_head: TOK_FUNCTION TOK_ID parameters TOK_COLON simple_type_decl {
	printf("function_head end: %s\n", $2);
}| error {
};

procedure_decl: procedure_head TOK_SEMI sub_routine TOK_SEMI {
};

procedure_head: TOK_PROCEDURE TOK_ID parameters {
	printf("procedure_head end: %s\n", $2);
}| error {
};

parameters: TOK_LP para_decl_list TOK_RP {
}| /*empty*/ {
};

para_decl_list: para_decl_list TOK_SEMI para_type_list {
}| para_type_list {
};

para_type_list: var_para_list TOK_COLON simple_type_decl {
}| val_para_list TOK_COLON simple_type_decl {
};

var_para_list: TOK_VAR name_list {
};

val_para_list: name_list {
};

routine_body: compound_stmt {
	printf("routine_body end\n");
};

stmt_list: stmt_list stmt TOK_SEMI {
}| /*empty*/ {
}| stmt_list error {
}| error {
};

stmt: TOK_INTEGER TOK_COLON non_label_stmt {
}| non_label_stmt {
};

non_label_stmt: assign_stmt {
}| proc_stmt {
}| compound_stmt {
}| if_stmt {
}| repeat_stmt {
}| while_stmt {
}| for_stmt {
}| case_stmt {
}| goto_stmt {
};

assign_stmt: TOK_ID TOK_ASSIGN expression {
}| TOK_ID TOK_LB expression TOK_RB TOK_ASSIGN expression {
}| TOK_ID TOK_DOT TOK_ID TOK_ASSIGN expression {
};

proc_stmt: TOK_ID {
}| TOK_ID TOK_LP args_list TOK_RP {
}| TOK_SYS_PROC {
}| TOK_SYS_PROC TOK_LP expression_list TOK_RP {
}| TOK_READ TOK_LP factor TOK_RP {
};

compound_stmt: TOK_BEGIN stmt_list TOK_END {
};

if_stmt: TOK_IF expression TOK_THEN stmt else_clause {
};

else_clause: TOK_ELSE stmt {
}| /*empty*/ {
};

repeat_stmt: TOK_REPEAT stmt_list TOK_UNTIL expression {
};

while_stmt: TOK_WHILE expression TOK_DO stmt {
};

for_stmt: TOK_FOR TOK_ID TOK_ASSIGN expression direction expression TOK_DO stmt {
};

direction: TOK_TO {
}| TOK_DOWNTO {
};

case_stmt: TOK_CASE expression TOK_OF case_expr_list TOK_END {
};

case_expr_list: case_expr_list case_expr {
}| case_expr {
};

case_expr: const_value TOK_COLON stmt TOK_SEMI {
}| TOK_ID TOK_COLON stmt TOK_SEMI {
}| error {
};

goto_stmt: TOK_GOTO TOK_INTEGER {
};

expression_list: expression_list TOK_COMMA expression {
}| expression {
};

expression: expression TOK_GE expr {
}| expression TOK_GT expr {
}| expression TOK_LE expr {
}| expression TOK_LT expr {
}| expression TOK_EQUAL expr {
}| expression TOK_UNEQUAL expr {
}| expr {
};

expr: expr TOK_PLUS term {
}| expr TOK_MINUS term {
}| expr TOK_OR term {
}| term {
};

term: term TOK_MUL factor {
}| term TOK_DIV factor {
}| term TOK_MOD factor {
}| term TOK_AND factor {
}| factor {
};

factor: TOK_ID {
}| TOK_ID TOK_LP args_list TOK_RP {
}| TOK_SYS_FUNCT {
}| TOK_SYS_FUNCT TOK_LP args_list TOK_RP {
}| const_value {
}| TOK_LP expression TOK_RP {
}| TOK_NOT factor {
}| TOK_MINUS factor {
}| TOK_ID TOK_LB expression TOK_RB {
}| TOK_ID TOK_DOT TOK_ID {
};

args_list: args_list TOK_COMMA expression {
}| expression {
};

%%

