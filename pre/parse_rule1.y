program: program_head routine TOK_DOT {
	routine_root = $2;
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
	$$ = type_new_ref($1, $3);
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
	$$ = type_new_ref($1, NULL);
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







