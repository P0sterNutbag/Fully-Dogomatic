extends Node2D

var max_spawn_amount = 3
var min_spawn_amount = 1
var spawn_time_multiplier = 3


func _on_spawn_timer_timeout():
	var spawn_amount = randi_range(min_spawn_amount, max_spawn_amount)
	spawn_enemies(load("res://Scenes/Enemies/enemy_pug.tscn"), spawn_amount, $SpawnPoint.global_position)
	$SpawnTimer.wait_time = spawn_amount * spawn_time_multiplier


func spawn_enemies(enemy, spawn_amount: int, spawn_position: Vector2):
	for n in spawn_amount:
		var instance = enemy.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = spawn_position
		instance.spawn_floor_y = global_position.y + randf_range(32,-32)


func _exit_tree():
	var pipes_left = get_tree().get_nodes_in_group("spawner").size()
	#if pipes_left <= 1:
		#get_tree().current_scene.get_node("LevelManager").spawn_portal()
