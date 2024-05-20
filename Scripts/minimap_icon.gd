extends Node2D

@export var sprite: Texture2D
@export var follow: bool
var icon: Node2D


func _ready():
	call_deferred("add_to_minimap")


func add_to_minimap():
	var minimap = Globals.ui.get_node("Minimap")
	var follow_obj
	if follow:
		follow_obj = get_parent()
	else:
		follow_obj = null
	icon = minimap.add_to_map(sprite, global_position, follow_obj)


func _exit_tree():
	icon.queue_free()
