extends Node2D

@export_subgroup("Properties")
@export var spread: float = -1
@export var distance_to_player: float = 10

var gun_parent


func set_gun_stats():
	gun_parent = get_parent().get_parent().get_parent().get_parent()
	if gun_parent is Gun:
		gun_parent.spread += spread
		gun_parent.distance_to_player += distance_to_player
