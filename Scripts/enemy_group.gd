extends Node2D

var spawn_radius: int = 75
var spawn_amount: int = 10
var amount_variance: int = 5
var spawn_position: Vector2


func _ready():
	var barrier_left = Globals.barrier_left
	var barrier_right = Globals.barrier_right
	match randi_range(0,3):
		0: spawn_position = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_left.y)
		1: spawn_position = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_right.y)
		2: spawn_position = Vector2(barrier_left.x, randf_range(barrier_left.y,barrier_right.y))
		3: spawn_position = Vector2(barrier_right.x, randf_range(barrier_left.y,barrier_right.y))
	for i in spawn_amount + randi_range(-amount_variance, amount_variance):
		var enemy = Globals.enemy_spawn_controller.get_enemy_to_spawn()
		Globals.create_instance(enemy, spawn_position + Vector2(randf_range(-spawn_radius, spawn_radius), randf_range(-spawn_radius, spawn_radius)))
