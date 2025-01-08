extends Node2D

@export var sprite: Texture2D
@export var follow: bool
@export var depth: int = 0
var icon: Node2D


func _enter_tree() -> void:
	call_deferred("add_to_minimap")


func add_to_minimap():
	var minimap = Globals.ui.get_node("Minimap")
	var follow_obj
	if follow:
		follow_obj = get_parent()
	else:
		follow_obj = null
	icon = minimap.add_to_map(sprite, global_position, follow_obj)
	icon.z_index = depth
	tree_exited.connect(icon.queue_free)
