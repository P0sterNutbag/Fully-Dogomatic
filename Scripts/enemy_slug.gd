extends Enemy

var baby = preload("res://Scenes/Enemies/enemy_slug_baby.tscn")

func on_death(bullet_direction: float = 0):
	for i in 3:
		Globals.create_instance(baby, global_position + Vector2(randf_range(-18, 18),randf_range(-8, 8)))
	super.on_death()
