#ifndef IR_H_
#define IR_H_

#define IR_TYPE_LOAD 0
#define IR_TYPE_STORE 1
#define IR_TYPE_PUSH 2
#define IR_TYPE_CALL 3
#define IR_TYPE_RET 4
#define IR_TYPE JZ 5
#define IR_TYPE_JNZ 6
#define IR_TYPE_JMP 7
#define IR_TYPE_MOVE 100
#define IR_TYPE_NEG 101
#define IR_TYPE_NOT 102
#define IR_TYPE_GE 200
#define IR_TYPE_GT 201
#define IR_TYPE_LE 202
#define IR_TYPE_LT 203
#define IR_TYPE_EQUAL 204
#define IR_TYPE_UNEQUAL 205
#define IR_TYPE_PLUS 206
#define IR_TYPE_MINUS 207
#define IR_TYPE_OR 208
#define IR_TYPE_MUL 209
#define IR_TYPE_DIV 210
#define IR_TYPE_MOD 211
#define IR_TYPE_AND 212
#define IR_TYPE_RDIV 213
#define IR(x) ((struct ir_s*)(x) - 1)
#define IR_LOAD ((struct ir_load_s*)((x) + 1))
#define IR_STORE((struct ir_store_s*)((x) + 1))
#define IR_PUSH ((struct ir_push_s*)((x) + 1))
#define IR_CALL ((struct ir_call_s*)((x) + 1))
#define IR_RET ((struct ir_ret_s*)((x) + 1))
#define IR_JZ ((struct ir_jz_s*)((x) + 1))
#define IR_JNZ ((struct ir_jnz_s*)((x) + 1))
#define IR_JMP ((struct ir_jmp_s*)((x) + 1))
#define IR_OP1 ((struct ir_op1_s*)((x) + 1))
#define IR_OP2 ((struct ir_op2_s*)((x) + 1))

struct ir_s {
	int type;
};


struct ir_load_s {
	struct expr_s *dest, *base, *ofs;
};

struct ir_store_s {
	struct expr_s *base, *ofs, *src;
};

struct ir_push_s {
	struct expr_s *src;
};

struct ir_call_s {
	struct expr_s *funct;
};

struct ir_ret_s {
	struct expr_s *src;
};

struct ir_jz_s {
	struct expr_s *cond;
	int label;
};

struct ir_jnz_s {
	struct expr_s *cond;
	int label;
};

struct ir_jmp_s {
	int label;
};

struct ir_op1_s {
	struct expr_s *dest, *src;
};

struct ir_op2_s {
	struct expr_s *dest, *src1, *src2;
};

struct ir_s* ir_new_load(struct expr_s *dest, struct expr_s *base, struct expr_s *ofs);
struct ir_s* ir_new_store(struct expr_s *base, struct expr_s *ofs, struct expr_s *src);
struct ir_s* ir_new_push(struct expr_s *src);
struct ir_s* ir_new_call(struct expr_s *funct);
struct ir_s* ir_new_ret(struct expr_s *src);
struct ir_s* ir_new_jz(int label, struct expr_s *cond);
struct ir_s* ir_new_jnz(int label, struct expr_s *cond);
struct ir_s* ir_new_jmp(int label);
struct ir_s* ir_new_op1(int type, struct expr_s *src);
struct ir_s* ir_new_op2(int type, struct expr_s *src1, struct expr_s *src2);

#endif

