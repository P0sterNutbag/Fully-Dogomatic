extends Enemy

var missile = preload("res://Scenes/Enemies/missile.tscn")
var missile_amount = 3


func on_death(bullet_direction: float = 0) -> void:
	for i in missile_amount:
		Globals.create_instance(missile, global_position)
	super.on_death(bullet_direction)
