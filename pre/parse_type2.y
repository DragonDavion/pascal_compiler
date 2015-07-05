/* start type list 2 */
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
/* end type list 2 */
%%
