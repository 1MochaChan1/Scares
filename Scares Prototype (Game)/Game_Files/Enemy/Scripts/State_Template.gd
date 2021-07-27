extends Node

var enemy_node

func _ready():
	enemy_node = get_tree().get_nodes_in_group("Enemy")[0]

func enter(host):
	return

func exit(host):
	return

func update(host, delta):
	return

func handle_input(host, delta):
	return
