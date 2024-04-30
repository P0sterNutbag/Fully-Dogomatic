extends Node2D

@export_subgroup("Properties")
@export var spread: float = -1


var gun_parent


func set_gun_stats():
	gun_parent = get_parent().get_parent().get_parent().get_parent()
	if gun_parent is Gun:
		print_debug(gun_parent)
		gun_parent.spread += spread
		print_debug(gun_parent.spread)
	
