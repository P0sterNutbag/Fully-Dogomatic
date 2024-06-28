extends Node2D


var spawners: Array
@export var spawn_rounds = []
@export var spawn_time: Array[float]
var spawn_round = 0
var spawn_amount_min = 1
var spawn_amount_max = 3
var enemy2_probability = 0
var enemy3_probability = 0


func _ready():
	Globals.enemy_spawn_controller = self
	for i in get_child_count():
		if get_child(i) is Node2D:
			spawners.append(get_child(i))


func _on_spawn_enemies_timeout():
	spawn_enemy()


func spawn_enemy():
	if get_tree().get_nodes_in_group("enemy").size() < 850:
		$SpawnEnemies.wait_time = spawn_time[spawn_round]
		var enemy = get_enemy_to_spawn()
		var spawn_position
		var barrier_left = Globals.world_controller.get_node("BarrierLeft").global_position
		var barrier_right = Globals.world_controller.get_node("BarrierRight").global_position
		match randi_range(0,3):
			0: spawn_position = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_left.y)
			1: spawn_position = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_right.y)
			2: spawn_position = Vector2(barrier_left.x, randf_range(barrier_left.y,barrier_right.y))
			3: spawn_position = Vector2(barrier_right.x, randf_range(barrier_left.y,barrier_right.y))	
		Globals.create_instance(enemy, spawn_position + Vector2(randf_range(-50,50), randf_range(-50,50)))


func get_enemy_to_spawn() -> PackedScene:
	return spawn_rounds[spawn_round][Globals.get_weighted_index(spawn_rounds[spawn_round])].object_to_spawn


func _on_spawn_round_timeout():
	spawn_round += 1


func _on_initial_spawn_timeout():
	spawn_enemy()


func _on_node_2d_stop_spawning_enemies():
	queue_free()

