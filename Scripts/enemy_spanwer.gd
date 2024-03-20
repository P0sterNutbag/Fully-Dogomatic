extends Node2D

#var enemy = preload("res://Scenes/enemy.tscn")
#var enemy2 = preload("res://Scenes/enemy_fast.tscn")
var spawn_amount_min: int = 1
var spawn_amount_max: int = 1 
var min_wait = 10
var max_wait = 30


#func _ready():
	#$SpawnEnemies.wait_time = randi_range(1, max_wait)
	#$SpawnEnemies.start()


func spawn_enemies(enemy):
	var spawn_amount = randi_range(spawn_amount_min, spawn_amount_max)
	for n in spawn_amount:
		var instance = enemy.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = get_random_position()


#func _on_spawn_enemies_timeout():
	#spawn_enemies()


func get_random_position():
	var spawn_position = Vector2(0,0)
	spawn_position.x = global_position.x + randi_range(-50, 50)
	spawn_position.y = global_position.y + randi_range(-50, 50)
	return spawn_position


#func _on_increase_difficulty_timeout():
	#spawn_amount_max += 1
	#if randi_range(0,1) == 1:
		#spawn_amount_min += 1
	#min_wait -= 1
	#
#
#func increase_difficulty(): 
	#spawn_amount_max += 1
	#if randi_range(0,1) == 1:
		#spawn_amount_min += 1
	#min_wait -= 1
	
