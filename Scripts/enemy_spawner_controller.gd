extends Node


var spawners: Array
@export var spawn_rounds = []
@export var spawn_time: Array[float]
var spawn_round = 0
var spawn_amount_min = 1
var spawn_amount_max = 3
var enemy2_probability = 0
var enemy3_probability = 0


func _ready() -> void:
	Globals.enemy_spawn_controller = self
	for i in get_child_count():
		if get_child(i) is Node2D:
			spawners.append(get_child(i))


func _on_spawn_enemies_timeout() -> void:
	spawn_enemy()


func spawn_enemy(enemy_to_spawn: PackedScene = null, spawn_position: Vector2 = Vector2.ONE):
	if get_tree().get_nodes_in_group("enemy").size() > 1000:
		return
	$SpawnEnemies.wait_time = float(spawn_time[spawn_round])
	var enemy = enemy_to_spawn
	if enemy == null:
		enemy = get_enemy_to_spawn()
	var pos = spawn_position
	if pos == Vector2.ONE:
		var spawn_left = Vector2(Globals.camera.get_screen_center_position().x - 240 - 32, Globals.camera.get_screen_center_position().y - 180 - 32)
		var spawn_right = Vector2(Globals.camera.get_screen_center_position().x + 240 + 32, Globals.camera.get_screen_center_position().y + 180 + 32)
		var barrier_left = Globals.world_controller.get_node("BarrierLeft").global_position - Vector2(25, 25)
		var barrier_right = Globals.world_controller.get_node("BarrierRight").global_position + Vector2(25, 25)
		spawn_left.x = clamp(spawn_left.x, barrier_left.x, barrier_right.x)
		spawn_left.y = clamp(spawn_left.y, barrier_left.y, barrier_right.y)
		spawn_right.x = clamp(spawn_right.x, barrier_left.x, barrier_right.x)
		spawn_right.y = clamp(spawn_right.y, barrier_left.y, barrier_right.y)
		match randi_range(0,3):
			0: pos = Vector2(randf_range(spawn_left.x,spawn_right.x), spawn_left.y)
			1: pos = Vector2(randf_range(spawn_left.x,spawn_right.x), spawn_right.y)
			2: pos = Vector2(spawn_left.x, randf_range(spawn_left.y,spawn_right.y))
			3: pos = Vector2(spawn_right.x, randf_range(spawn_left.y,spawn_right.y))	
	Globals.create_instance(enemy, pos)


func get_enemy_to_spawn() -> PackedScene:
	return spawn_rounds[spawn_round][Globals.get_weighted_index(spawn_rounds[spawn_round])].object_to_spawn


func _on_spawn_round_timeout() -> void:
	spawn_round = clamp(spawn_round + 1, 0, spawn_rounds.size()-1)


func _on_initial_spawn_timeout() -> void:
	spawn_enemy()


func _on_node_2d_stop_spawning_enemies() -> void:
	queue_free()
