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
	char *string;
	struct routine_s *routine;
	struct const_def_s *const_def;
	struct type_s *type;
	struct field_s *field;
	struct name_list_s *name_list;
	struct var_s *var;
	struct routine_proto_s *routine_proto;
	struct param_s *param;
	struct param_item_s *param_item;
	struct stmt_s *stmt;
	struct case_expr_s *case_expr;
	struct expr_s *expr;
	struct dummy_s *dummy;
}

%token <string> TOK_AND
%token <string> TOK_ARRAY
%token <string> TOK_ASSIGN
%token <string> TOK_BEGIN
%token <string> TOK_CASE
%token <string> TOK_CHAR
%token <string> TOK_COLON
%token <string> TOK_COMMA
%token <string> TOK_CONST
%token <string> TOK_DIV
%token <string> TOK_DO
%token <string> TOK_DOT
%token <string> TOK_DOTDOT
%token <string> TOK_DOWNTO
%token <string> TOK_ELSE
%token <string> TOK_END
%token <string> TOK_EQUAL
%token <string> TOK_FOR
%token <string> TOK_FUNCTION
%token <string> TOK_GE
%token <string> TOK_GOTO
%token <string> TOK_GT
%token <string> TOK_ID
%token <string> TOK_IF
%token <string> TOK_INTEGER
%token <string> TOK_LB
%token <string> TOK_LE
%token <string> TOK_LP
%token <string> TOK_LT
%token <string> TOK_MINUS
%token <string> TOK_MOD
%token <string> TOK_MUL
%token <string> TOK_NOT
%token <string> TOK_OF
%token <string> TOK_OR
%token <string> TOK_PLUS
%token <string> TOK_PROCEDURE
%token <string> TOK_PROGRAM
%token <string> TOK_RB
%token <string> TOK_RDIV
%token <string> TOK_READ
%token <string> TOK_REAL
%token <string> TOK_RECORD
%token <string> TOK_REPEAT
%token <string> TOK_RP
%token <string> TOK_SEMI
%token <string> TOK_STRING
%token <string> TOK_SYS_CON
%token <string> TOK_SYS_FUNCT
%token <string> TOK_SYS_PROC
%token <string> TOK_SYS_TYPE
%token <string> TOK_THEN
%token <string> TOK_TO
%token <string> TOK_TYPE
%token <string> TOK_UNEQUAL
%token <string> TOK_UNKNOW_CHAR
%token <string> TOK_UNTIL
%token <string> TOK_VAR
%token <string> TOK_WHILE
%type <routine> program
%type <routine> program_head
%type <routine> routine
%type <routine> sub_routine
%type <routine> routine_head
/*%type <dummy> label_part*/
%type <const_def> const_part
%type <const_def> const_expr_list
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
%type <var> var_part
%type <var> var_decl_list
%type <var> var_decl
%type <routine> routine_part
%type <routine> function_decl
%type <routine_proto> function_head
%type <routine> procedure_decl
%type <routine_proto> procedure_head
%type <param> parameters
%type <param> para_decl_list
%type <param_item> para_type_list
%type <name_list> var_para_list
%type <name_list> val_para_list
%type <stmt> routine_body
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
	$$ = $2;
};

program_head: TOK_PROGRAM TOK_ID TOK_SEMI {
}| error;

routine: routine_head routine_body {
	$$ = routine_fill_body($1, $2);
};

sub_routine: routine_head routine_body {
	$$ = routine_fill_body($1, $2);
};

routine_head: label_part const_part type_part var_part routine_part {
	$$ = routine_new($2, $3, $4, $5);
};

label_part: %empty {
};

const_part: TOK_CONST const_expr_list {
	$$ = $2;
}| %empty {
	$$ = NULL;
};

const_expr_list: const_expr_list TOK_ID TOK_EQUAL const_value TOK_SEMI {
	$$ = const_def_push($1, $2, $4);
}| TOK_ID TOK_EQUAL const_value TOK_SEMI {
	$$ = const_def_push(NULL, $1, $3);
}| const_expr_list error {
	$$ = NULL;
}| error {
	$$ = NULL;
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
	$$ = type_new_enum($2);
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
	$$ = $2;
}| %empty {
	$$ = NULL;
};

var_decl_list: var_decl_list var_decl {
	$$ = var_push($1, $2);
}| var_decl {
	$$ = var_push(NULL, $1);
}| var_decl_list error {
	$$ = NULL;
}| error {
	$$ = NULL;
};

var_decl: name_list TOK_COLON type_decl TOK_SEMI {
	$$ = var_new($1, $3);
};

routine_part: routine_part function_decl {
	$$ = routine_push($1, $2);
}| routine_part procedure_decl {
	$$ = routine_push($1, $2);
}| function_decl {
	$$ = routine_push(NULL, $1);
}| procedure_decl {
	$$ = routine_push(NULL, $1);
}| %empty {
	$$ = NULL;
};

function_decl: function_head TOK_SEMI sub_routine TOK_SEMI {
	$$ = routine_fill_proto($3, $1);
};

function_head: TOK_FUNCTION TOK_ID parameters TOK_COLON simple_type_decl {
	$$ = routine_proto_new($2, $3, $5);
}| error {
	$$ = NULL;
};

procedure_decl: procedure_head TOK_SEMI sub_routine TOK_SEMI {
	$$ = routine_fill_proto($3, $1);
};

procedure_head: TOK_PROCEDURE TOK_ID parameters {
	$$ = routine_proto_new($2, $3, NULL);
}| error {
	$$ = NULL;
};

parameters: TOK_LP para_decl_list TOK_RP {
	$$ = $2;
}| %empty {
	$$ = NULL;
};

para_decl_list: para_decl_list TOK_SEMI para_type_list {
	$$ = param_push($1, $3);
}| para_type_list {
	$$ = param_push(NULL, $1);
};

para_type_list: var_para_list TOK_COLON simple_type_decl {
	$$ = para_item_new($1, $3, 1);
}| val_para_list TOK_COLON simple_type_decl {	
	$$ = para_item_new($1, $3, 0);
};

var_para_list: TOK_VAR name_list {
	$$ = $2;
};

val_para_list: name_list {
	$$ = $1;
};

routine_body: compound_stmt {
	$$ = $1;
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

