extends Node2D


var gun: Node2D


func _ready():
	gun = get_parent()
	gun.damage += 1
