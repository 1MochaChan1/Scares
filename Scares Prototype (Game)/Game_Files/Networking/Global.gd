extends Node

func instance_node_at_loc(node: Object, parent: Object, location: Vector2) -> Object:
	var node_instance = instance_node(node, parent)
	node_instance.global_position = location
	return node_instance

func instance_node(node: Object, parent: Object) -> Object:
	var node_instance = node.instance() #Create instance of a node
	parent.add_child(node_instance) # Adds the created instance to the parent.
	return node_instance
