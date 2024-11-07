extends Enemy

var dust = preload("res://Scenes/Particles/dust.tscn")

func on_damage():
	super.on_damage()
	if health_component.health <= 0:
		return
	for i in 8:
		var inst = Globals.create_instance(dust, global_position + Vector2(randf_range(-16, 16), randf_range(-16, 16)))
	var new_vec = (Globals.player.global_position - global_position) * 0.75
	global_position = Globals.player.global_position +new_vec.rotated(deg_to_rad(randf_range(0,360)))
