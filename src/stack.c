#include "stack.h"
#include <stdlib.h>
#include <malloc.h>

struct stack_s *new_stack()
{
	struct stack_s *tmp = NULL;
	
	if((tmp = (struct stack_s *)malloc(sizeof(struct stack_s))) == NULL) {
		// TODO
	} else {
		tmp->count = 0;
		tmp->current = NULL;
	}
	
	return tmp;
}

void destroy_stack(struct stack_s *stack)
{
	int i;
	struct stack_node_s *current = stack->current, *tmp;
	
	for(i = 0; i < stack->count; i++) {
		free(current->content_ptr);
		tmp = current;
		current  = current->prev;
		free(tmp);
	}
	free(stack);
	
	return;
}

int push(struct stack_s *stack, void *content_ptr)
{
	struct stack_node_s *new_node = NULL;
	
	if((new_node = (struct stack_node_s *)malloc(sizeof(struct stack_node_s))) == NULL) {
		// TODO
	} else {
		new_node->content_ptr = content_ptr;
		new_node->prev = stack->current;
		stack->current = new_node;
		stack->count++;
	}
	
	return 0;
}

void *pop(struct stack_s *stack)
{
	void *ret = NULL;
	struct stack_node_s *current = stack->current;
	
	if(stack->count > 0) {
		ret = stack->current;
		stack->current = current->prev;
		free(current->content->ptr);
		free(current);
		stack->count--;
	}
	
	return ret;
}

