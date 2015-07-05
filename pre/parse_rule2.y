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




