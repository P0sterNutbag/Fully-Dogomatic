extends EnemyIncramental

var enemy_small = preload("res://Scenes/Enemies/enemy_small.tscn")


func on_death(bullet_direction: float = 0):
	Globals.level_manager.spawn_enemy(enemy_small, false, global_position)
	super.on_death(bullet_direction)
