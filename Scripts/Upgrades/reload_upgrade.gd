extends Node2D


var gun: Node2D


func _ready():
	gun = get_parent()
	gun.reload_time *= 0.5
	gun.get_node("ReloadTimer").wait_time = gun.reload_time
