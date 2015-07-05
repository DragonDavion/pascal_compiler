%%

const char* get_token_name(int token_id) {
	return yytname[token_id - 255];
}

