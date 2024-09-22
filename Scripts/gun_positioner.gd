extends Node2D

var parent

func _ready() -> void:
	parent = get_parent()


func _process(delta: float) -> void:
	if parent.holder != null:
		parent.position = lerp(parent.position, parent.aim_dir * parent.distance_to_player, delta * 10)
