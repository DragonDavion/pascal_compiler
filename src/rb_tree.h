#ifndef _RB_TREE_H
#define _RB_TREE_H

#define RB_TREE_RED		0
#define RB_TREE_BLACK	1

struct rb_tree_s
{
	struct rb_tree_node_s *root;
};

struct rb_tree_node_s
{
	int color;
	void *value;
	void *content_ptr;
	struct rb_tree_node_s *left, *right, *parent;
};

struct rb_tree_s *new_rb_tree();
int insert_into_rb_tree(struct rb_tree_s *tree, void *value, int(void*,void*), void *content);

#endif /* _RB_TREE_H */

