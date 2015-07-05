/* start type list 1 */
%type <dummy> program
%type <routine> program_head
%type <routine> routine
%type <routine> sub_routine
%type <routine> routine_head
%type <dummy> label_part
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
/* end type list 1 */
