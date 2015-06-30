#ifndef MAIN_H_
#define MAIN_H_

#include "parse.tab.h"

int yywarp();
void yyerror(const YYLTYPE*, const char*);

extern struct routine_s *routine_root;

#endif

