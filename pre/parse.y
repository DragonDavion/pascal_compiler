%{
#include <stdio.h>
#include <stdlib.h>
#include "main.h"
int yylex(YYSTYPE*, YYLTYPE*);
%}

%code requires {
#include "expr.h"
#include "stmt.h"
}

%locations
%token-table
%define api.pure full
%define parse.lac full
%define parse.error verbose

%union {
	char *str;
	struct type_s *type;
	struct field_s *field;
	struct name_list_s *name_list;
	struct stmt_s *stmt;
	struct case_expr_s *case_expr;
	struct expr_s *expr;
	struct dummy_s *dummy;
}

%token <str> TOK_AND
%token <str> TOK_ARRAY
%token <str> TOK_ASSIGN
%token <str> TOK_BEGIN
%token <str> TOK_CASE
%token <str> TOK_CHAR
%token <str> TOK_COLON
%token <str> TOK_COMMA
%token <str> TOK_CONST
%token <str> TOK_DIV
%token <str> TOK_DO
%token <str> TOK_DOT
%token <str> TOK_DOTDOT
%token <str> TOK_DOWNTO
%token <str> TOK_ELSE
%token <str> TOK_END
%token <str> TOK_EQUAL
%token <str> TOK_FOR
%token <str> TOK_FUNCTION
%token <str> TOK_GE
%token <str> TOK_GOTO
%token <str> TOK_GT
%token <str> TOK_ID
%token <str> TOK_IF
%token <str> TOK_INTEGER
%token <str> TOK_LB
%token <str> TOK_LE
%token <str> TOK_LP
%token <str> TOK_LT
%token <str> TOK_MINUS
%token <str> TOK_MOD
%token <str> TOK_MUL
%token <str> TOK_NOT
%token <str> TOK_OF
%token <str> TOK_OR
%token <str> TOK_PLUS
%token <str> TOK_PROCEDURE
%token <str> TOK_PROGRAM
%token <str> TOK_RB
%token <str> TOK_RDIV
%token <str> TOK_READ
%token <str> TOK_REAL
%token <str> TOK_RECORD
%token <str> TOK_REPEAT
%token <str> TOK_RP
%token <str> TOK_SEMI
%token <str> TOK_STRING
%token <str> TOK_SYS_CON
%token <str> TOK_SYS_FUNCT
%token <str> TOK_SYS_PROC
%token <str> TOK_SYS_TYPE
%token <str> TOK_THEN
%token <str> TOK_TO
%token <str> TOK_TYPE
%token <str> TOK_UNEQUAL
%token <str> TOK_UNKNOW_CHAR
%token <str> TOK_UNTIL
%token <str> TOK_VAR
%token <str> TOK_WHILE
%type <dummy> program
%type <dummy> program_head
%type <dummy> routine
%type <dummy> sub_routine
%type <dummy> routine_head
%type <dummy> label_part
%type <dummy> const_part
%type <dummy> const_expr_list
%type <expr> const_value
%type <type> type_part
%type <type> type_decl_list
%type <type> type_definition
%type <type> type_decl
%type <type> array_type_decl
%type <type> record_type_decl
%type <field> field_decl_list
%type <field> field_decl
%type <name_list> name_list
%type <type> simple_type_decl
%type <dummy> var_part
%type <dummy> var_decl_list
%type <dummy> var_decl
%type <dummy> routine_part
%type <dummy> function_decl
%type <dummy> function_head
%type <dummy> procedure_decl
%type <dummy> procedure_head
%type <dummy> parameters
%type <dummy> para_decl_list
%type <dummy> para_type_list
%type <dummy> var_para_list
%type <dummy> val_para_list
%type <dummy> routine_body
%type <stmt> stmt_list
%type <stmt> stmt
%type <stmt> non_label_stmt
%type <stmt> assign_stmt
%type <stmt> proc_stmt
%type <stmt> compound_stmt
%type <stmt> if_stmt
%type <stmt> else_clause
%type <stmt> repeat_stmt
%type <stmt> while_stmt
%type <stmt> for_stmt
%type <stmt> direction
%type <stmt> case_stmt
%type <stmt> case_expr_list
%type <case_expr> case_expr
%type <stmt> goto_stmt
%type <expr> expression_list
%type <expr> expression
%type <expr> expr
%type <expr> term
%type <expr> factor
%type <expr> args_list
%%

program: program_head routine TOK_DOT {
	//$$ = ast_program_new($1, $2);
};

program_head: TOK_PROGRAM TOK_ID TOK_SEMI {
	//$$ = ast_program_head_new($2);
}| error;

routine: routine_head routine_body {
	//$$ = ast_routine_new($1, $2);
};

sub_routine: routine_head routine_body {
	//$$ = ast_sub_routine_new($1, $2);
};

routine_head: label_part const_part type_part var_part routine_part {
	//$$ = ast_routine_head_new($1, $2, $3, $4, $5);
};

label_part: %empty {
	//$$ = ast_label_part_new();
};

const_part: TOK_CONST const_expr_list {
	//$$ = ast_const_part_new($2);
}| %empty {
	//$$ = ast_const_part_new(NULL);
};

const_expr_list: const_expr_list TOK_ID TOK_EQUAL const_value TOK_SEMI {
	//$$ = ast_const_expr_list_new($1, $2, $4);
}| TOK_ID TOK_EQUAL const_value TOK_SEMI {
	//$$ = ast_const_expr_list_new(NULL, $1, $3);
}| const_expr_list error {
	//$$ = NULL;
}| error {
	//$$ = NULL;
};

const_value: TOK_INTEGER {
	$$ = expr_new_integer($1);
}| TOK_REAL {
	$$ = expr_new_real($1);
}| TOK_CHAR {
	$$ = expr_new_char($1);
}| TOK_STRING {
	$$ = expr_new_string($1);
}| TOK_SYS_CON {
	$$ = expr_new_sys_con($1);
};

type_part: TOK_TYPE type_decl_list {
	$$ = $2;
}| %empty {
	$$ = NULL;
};

type_decl_list: type_decl_list type_definition {
	$$ = type_push($1, $2);
}| type_definition {
	$$ = type_push(NULL, $1);
}| type_decl_list error {
	$$ = NULL;
}| error {
	$$ = NULL;
};

type_definition: TOK_ID TOK_EQUAL type_decl TOK_SEMI {
	$$ = type_fill_name($3, $1);
};

type_decl: simple_type_decl {
	$$ = $1;
}| array_type_decl {
	$$ = $1;
}| record_type_decl {
	$$ = $1;
};

array_type_decl: TOK_ARRAY TOK_LB simple_type_decl TOK_RB TOK_OF type_decl {
	$$ = type_new_array($3, $6);
};

record_type_decl: TOK_RECORD field_decl_list TOK_END {
	$$ = type_new_record($2);
};

field_decl_list: field_decl_list field_decl {
	$$ = field_push($1, $2);
}| field_decl {
	$$ = field_push(NULL, $1);
};

field_decl: name_list TOK_COLON type_decl TOK_SEMI {
	$$ = field_new($1, $3);
};

name_list: name_list TOK_COMMA TOK_ID {
	$$ = name_list_push($1, $3);
}| TOK_ID {
	$$ = name_list_push(NULL, $1);
};

simple_type_decl: TOK_SYS_TYPE {
	$$ = type_new_sys($1);
}| TOK_ID {
	$$ = type_new_equal($1);
}| TOK_LP name_list TOK_RP {
	$$ = type_new_enum($1);
}| const_value TOK_DOTDOT const_value {
	$$ = type_new_sub($1, $3, 1, 1);
}| TOK_MINUS const_value TOK_DOTDOT const_value {
	$$ = type_new_sub($2, $4, -1, 1)
}| TOK_MINUS const_value TOK_DOTDOT TOK_MINUS const_value {
	$$ = type_new_sub($2, $5, -1, -1);
}| TOK_ID TOK_DOTDOT TOK_ID {
	struct expr_s expr1 = expr_new_var($1);
	struct expr_s expr2 = expr_new_var($3);
	$$ = type_new_sub(expr1, expr2);
};

var_part: TOK_VAR var_decl_list {
	//$$ = ast_var_part_new($2);
}| %empty {
	//$$ = NULL;
};

var_decl_list: var_decl_list var_decl {
	//$$ = ast_var_decl_list_new($1, $2);
}| var_decl {
	//$$ = ast_var_decl_list_new(NULL, $1);
}| var_decl_list error {
	//$$ = NULL;
}| error {
	//$$ = NULL;
};

var_decl: name_list TOK_COLON type_decl TOK_SEMI {
	//$$ = ast_var_decl_new($1, $3);
};

routine_part: routine_part function_decl {
	//$$ = ast_routine_part_new_f($1, $2);
}| routine_part procedure_decl {
	//$$ = ast_routine_part_new_p($1, $2);
}| function_decl {
	//$$ = ast_routine_part_new_f(NULL, $1);
}| procedure_decl {
	//$$ = ast_routine_part_new_p(NULL, $1);
}| %empty {
	//$$ = NULL;
};

function_decl: function_head TOK_SEMI sub_routine TOK_SEMI {
	//$$ = ast_function_decl_new($1, $3);
};

function_head: TOK_FUNCTION TOK_ID parameters TOK_COLON simple_type_decl {
	//$$ = ast_function_head_new($2, $3, $5);
}| error {
	//$$ = NULL;
};

procedure_decl: procedure_head TOK_SEMI sub_routine TOK_SEMI {
	//$$ = ast_procedure_decl_new($1, $3);
};

procedure_head: TOK_PROCEDURE TOK_ID parameters {
	//$$ = ast_procedure_head_new($2, $3);
}| error {
	//$$ = NULL;
};

parameters: TOK_LP para_decl_list TOK_RP {
	//$$ = ast_parameters_new($2);
}| %empty {
	//$$ = NULL;
};

para_decl_list: para_decl_list TOK_SEMI para_type_list {
	//$$ = ast_para_decl_list_new($1, $3);
}| para_type_list {
	//$$ = ast_para_decl_list_new(NULL, $1);
};

para_type_list: var_para_list TOK_COLON simple_type_decl {
	//$$ = ast_para_type_list_new_var($1, $3);
}| val_para_list TOK_COLON simple_type_decl {
	//$$ = ast_para_type_list_new_val($1, $3);
};

var_para_list: TOK_VAR name_list {
	//$$ = ast_var_para_list_new($2);
};

val_para_list: name_list {
	//$$ = ast_val_para_list_new($1);
};

routine_body: compound_stmt {
	//$$ = ast_routine_body_new($1);
};

stmt_list: stmt_list stmt TOK_SEMI {
	$$ = stmt_push($1, $2);
}| %empty {
	$$ = NULL;
}| stmt_list error {
	$$ = NULL;
}| error {
	$$ = NULL;
};

stmt: TOK_INTEGER TOK_COLON non_label_stmt {
	$$ = stmt_label($3, $1);
}| non_label_stmt {
	$$ = $1;
};

non_label_stmt: assign_stmt {
	$$ = $1;
}| proc_stmt {
	$$ = $1;
}| compound_stmt {
	$$ = $1;
}| if_stmt {
	$$ = $1;
}| repeat_stmt {
	$$ = $1;
}| while_stmt {
	$$ = $1;
}| for_stmt {
	$$ = $1;
}| case_stmt {
	$$ = $1;
}| goto_stmt {
	$$ = $1;
};

assign_stmt: TOK_ID TOK_ASSIGN expression {
	struct expr_s *expr = expr_new_var($1);
	$$ = stmt_new_assign(expr, $3);
}| TOK_ID TOK_LB expression TOK_RB TOK_ASSIGN expression {
	struct expr_s *expr = expr_new_array($1, $3);
	$$ = stmt_new_assign(expr, $6);
}| TOK_ID TOK_DOT TOK_ID TOK_ASSIGN expression {
	struct expr_s *expr = expr_new_record($1, $3);
	$$ = stmt_new_assign(expr, $5);
};

proc_stmt: TOK_ID {
	$$ = stmt_new_proc($1, NULL);
}| TOK_ID TOK_LP args_list TOK_RP {
	$$ = stmt_new_proc($1, $3);
}| TOK_SYS_PROC {
	$$ = stmt_new_proc($1, NULL);
}| TOK_SYS_PROC TOK_LP expression_list TOK_RP {
	$$ = stmt_new_proc($1, $3);
}| TOK_READ TOK_LP factor TOK_RP {
	$$ = stmt_new_proc($1, $3);
};

compound_stmt: TOK_BEGIN stmt_list TOK_END {
	$$ = $2;
};

if_stmt: TOK_IF expression TOK_THEN stmt else_clause {
	$$ = stmt_fill_if($5, $2, $4);
};

else_clause: TOK_ELSE stmt {
	$$ = stmt_new_if($2);
}| %empty {
	$$ = stmt_new_if(NULL);
};

repeat_stmt: TOK_REPEAT stmt_list TOK_UNTIL expression {
	$$ = stmt_new_repeat($2, $4);
};

while_stmt: TOK_WHILE expression TOK_DO stmt {
	$$ = stmt_new_while($2, $4);
};

for_stmt: TOK_FOR TOK_ID TOK_ASSIGN expression direction expression TOK_DO stmt {
	$$ = stmt_fill_for($4, $2, $5, $6, $8);
};

direction: TOK_TO {
	$$ = stmt_new_for(1);
}| TOK_DOWNTO {
	$$ = stmt_new_for(-1);
};

case_stmt: TOK_CASE expression TOK_OF case_expr_list TOK_END {
	$$ = stmt_new_case($2, $4);
};

case_expr_list: case_expr_list case_expr {
	$$ = case_expr_push($1, $2);
}| case_expr {
	$$ = $1;
};

case_expr: const_value TOK_COLON stmt TOK_SEMI {	
	$$ = case_expr_new($1, $3);
}| TOK_ID TOK_COLON stmt TOK_SEMI {
	struct expr_s *expr = expr_new_var($1);
	$$ = case_expr_new(expr, $3);
}| error {
	$$ = NULL;
};

goto_stmt: TOK_GOTO TOK_INTEGER {
	$$ = stmt_new_goto($2);
};

expression_list: expression_list TOK_COMMA expression {
	$$ = expr_new_op(TOK_COMMA, $1, $3);
}| expression {
	$$ = $1;
};

expression: expression TOK_GE expr {
	$$ = expr_new_op(TOK_GE, $1, $3);
}| expression TOK_GT expr {
	$$ = expr_new_op(TOK_GT, $1, $3);
}| expression TOK_LE expr {
	$$ = expr_new_op(TOK_LE, $1, $3);
}| expression TOK_LT expr {
	$$ = expr_new_op(TOK_LT, $1, $3);
}| expression TOK_EQUAL expr {
	$$ = expr_new_op(TOK_EQUAL, $1, $3);
}| expression TOK_UNEQUAL expr {
	$$ = expr_new_op(TOK_UNEQUAL, $1, $3);
}| expr {
	$$ = $1;
};

expr: expr TOK_PLUS term {
	$$ = expr_new_op(TOK_PLUS, $1, $3);
}| expr TOK_MINUS term {
	$$ = expr_new_op(TOK_MINUS, $1, $3);
}| expr TOK_OR term {
	$$ = expr_new_op(TOK_OR, $1, $3);
}| term {
	$$ = $1;
};

term: term TOK_MUL factor {
	$$ = expr_new_op(TOK_MUL, $1, $3);
}| term TOK_DIV factor {
	$$ = expr_new_op(TOK_DIV, $1, $3);
}| term TOK_MOD factor {
	$$ = expr_new_op(TOK_MOD, $1, $3);
}| term TOK_AND factor {
	$$ = expr_new_op(TOK_AND, $1, $3);
}| term TOK_RDIV factor {
	$$ = expr_new_op(TOK_RDIV, $1, $3);
}| factor {
	$$ = $1;
};

factor: TOK_ID {
	$$ = expr_new_var($1);
}| TOK_ID TOK_LP args_list TOK_RP {
	$$ = expr_new_funct($1, $3);
}| TOK_SYS_FUNCT {
	$$ = expr_new_funct($1, NULL);
}| TOK_SYS_FUNCT TOK_LP args_list TOK_RP {
	$$ = expr_new_funct($1, $3);
}| const_value {
	$$ = $1;
}| TOK_LP expression TOK_RP {
	$$ = $2;
}| TOK_NOT factor {
	$$ = expr_new_op(TOK_NOT, NULL, $2);
}| TOK_MINUS factor {
	$$ = expr_new_op(TOK_MINUS, NULL, $2);
}| TOK_ID TOK_LB expression TOK_RB {
	$$ = expr_new_array($1, $3);
}| TOK_ID TOK_DOT TOK_ID {
	$$ = expr_new_record($1, $3);
};

args_list: args_list TOK_COMMA expression {
	$$ = expr_new_op(TOK_COMMA, $1, $3);
}| expression {
	$$ = $1;
};

%%

const char* get_token_name(int token_id) {
	return yytname[token_id - 255];
}

