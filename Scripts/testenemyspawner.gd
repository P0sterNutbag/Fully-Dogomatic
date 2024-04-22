extends Node2D

var enemy #= preload("res://Scenes/enemy.tscn")


func _process(_delta):
	if get_tree().get_nodes_in_group("enemy").size() < 400:
		for n in 1:
			var instance = enemy.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = global_position
