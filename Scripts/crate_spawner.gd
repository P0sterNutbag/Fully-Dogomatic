extends Node2D

var crate = preload("res://Scenes/crate.tscn")
var target_y: float


func spawn_crate():
	# spawn crate
	global_position.x = get_parent().global_position.x + randf_range(-200, 200)#randf_range(-720,720)
	target_y = get_parent().global_position.y + randf_range(-100, 100)
	var inst = crate.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	inst.target_y = target_y
	