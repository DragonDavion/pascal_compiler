
/* */
/* requirement */
/* */

// sytax error
// if we detect sytax error, we will not do any further analyse

// semantic error
/* if we detect semantic error, we will not do any further analyse in the same unit
and we must mark the semantic error on the unit
and mark the unit to be sematic error which the unit reference a semantic unit
a unit means a const, a variable, a type, a expression

e.g.
const
	s = 1;
type
	x = s;
	y = integer;
var
	v : x;
we detect semantic error in x, so x is semantic errored
but y is not semantic errored
'type part' is not semantic errored
v is semantic errored
*/

// interface
// the routine that is under analysing
int current_routine_id;
// total size of variables
int total_var_size;
// total size of parameters
int total_param_size;
// type of the search result: CONST VAR PARAM TYPE FUNCT PROC
int result_type(struct symtab_result_s *result);
// does the search result has semantic error?
int has_error(struct symtab_result_s *result);
// symbol table search, return 0/1 if not found/found
int search_id(struct symtab_result_s *result, char *str);
// get the offset of the variables
int get_var_ofs(struct symtab_result_s *result);
// check if the param is reference
int is_ref_param(struct symtab_result_s *result);
// get the offset of the params
int get_param_ofs(struct symtab_result_s *result);
// get the size of TYPE
int get_type_size(struct symtab_result_s *result);
// check the type of TYPE
int is_record_type(struct symtab_result_s *result);
// check the tpye of TYPE
int is_normal_type(struct symtab_result_s *result);
// check the tpye of TYPE
int is_array_type(struct symtab_result_s *result);
// for record type, search the field, return 0/1 if not found/found
int search_field(struct symtab_result_s *result, char *str);
// after search filed, i'll call it to get the field offset
// i may also call is_**_type() and ssymtab_search_field() too
int get_field_ofs(struct symtab_result_s *result);
// for array type, get the min/max index
int get_array_min(struct symtab_result_s *result);
int get_array_max(struct symtab_result_s *result);
// get the basic type of the array, just like seach_field(), i may call other function later
void get_array_basic(struct symtab_result_s *result);
// for funct, I may get it's return type
void get_return_type(struct symtab_result_s *result);
// for funct & proc, I may get it's routine id
int get_routine_id(struct symtab_result_s *result);
// for funct & proc, I may need to get all params
// first time I call it, locate to the rightmost param, the result is the same as I search the name of the param
// next time I call it, locate to the left one
// if the one in the *result is the leftmost param, return 0
int get_param(struct symtab_result_s *result);
// after previous call, I may need to get the left one in the params, return 0 if no param

// check if the two type are the same, I promise r1 and r2 does not have semantic error (comment 1)
int type_check(struct symtab_result_s *r1, struct symtab_result_s *r2);


// comment 1: I promise that *result does not have semantic error before each call, except result_type, has_error, search_id
