#ifndef _STACK_H
#define _STACK_H

struct stack_s
{
	int count;
	struct stack_node_s *current;
};

struct stack_node_s
{
	struct stack_node_s *prev;
	void *content_ptr;
};

struct stack_s *new_stack();
void destroy_stack(struct stack_s *stack);
int push(stack_s *stack, void *content_ptr);
void *pop(stack_s *stack);

#endif

