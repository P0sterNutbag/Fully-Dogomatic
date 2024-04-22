extends Node2D

@export_subgroup("Properties")
@export var spread: float = -1

var gun_parent

func _ready():
	gun_parent = get_parent().get_parent().get_parent()#.get_parent()
	if gun_parent is Gun:
		gun_parent.spread += spread
	
