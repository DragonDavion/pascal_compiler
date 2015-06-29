#include "rb_tree.h"
#include <stdlib.h>
#include <malloc.h>

struct rb_tree_node_s *new_rb_tree()
{
	return NULL;
}

static struct rb_tree_node_s *get_grandparent(struct rb_tree_node_s *node)
{
	struct rb_tree_node_s *parent = node->parent;
	
	if(parent == NULL)
		return NULL;
	else
		return parent->parent;
}

static struct rb_tree_node_s *get_uncle(struct rb_tree_node_s *node)
{
	struct rb_tree_node_s *grandparent = get_grandparent(node), *parent = node->parent;
	
	if(grandparent == NULL)
		return NULL;
	else if()
}

static void insert_case(struct rb_tree_node_s *node)
{
	if(node->parent->color == RB_TREE_RED) {
		
	}
}

struct rb_tree_node_s *insert_into_rb_tree(struct rb_tree_node_s *node, void *value, int cmp_func(void *, void *), void *content)
{
	struct rb_tree_node_s *tmp_node;
	
	if((tmp_node = (struct rb_tree_node_s *)malloc(sizeof(struct rb_tree_node_s))) == NULL) {
		// TODO
	}
	
	if(node == NULL) {
		tmp_node->color = RB_TREE_BLACK;
		tmp_node->value = value;
		tmp_node->left = tmp_node->rigth = tmp_node->parent = NULL;
	} 
	else if(cmp_func(value, node->value) < 0) {
		if(node->left != NULL)
			insert_into_rb_tree(node->left, value, cmp_func, content);
		else {
			tmp_node->value = value;
			tmp_node->left = tmp_node->right = NULL;
			tmp_node->parent = node;
			node->left = tmp_node;
			insert_case(tmp_node);
		}
	}
	else {
		if(node->right != NULL)
			insert_into_rb_tree(node->right, value, cmp_func, content);
		else {
			struct rb_tree_node_s *tmp_node;
			tmp_node->value = value;
			tmp_node->left = tmp_node->rigth = NULL;
			tmp_node->parent = node;
			node->right = tmp_node;
			insert_case(tmp_node);
		}
	}
	
	return tmp_node;
}

