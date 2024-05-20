extends Node

@export var crate_amount: Array[int]
@export var enemy_spawner_amount: Array[int]
var crate = preload("res://Scenes/crate.tscn")
var enemy_spawner = preload("res://Scenes/enemy_spawner_pipe.tscn")
var crate_amount_variance: int = 3
var enemy_spawner_variance: int = 1


func _ready():
	var level: int = 0
	var world = get_tree().current_scene
	var barrier_left = world.get_node("BarrierLeft")
	var barrier_right = world.get_node("BarrierRight")
	for i in crate_amount[level] + randi_range(-crate_amount_variance, crate_amount_variance):
		var inst = crate.instantiate()
		world.call_deferred("add_child", inst)
		inst.global_position = Vector2(randf_range(barrier_left.position.x, barrier_right.position.x), randf_range(barrier_left.position.y, barrier_right.position.y))
	for i in enemy_spawner_amount[level] + randi_range(-enemy_spawner_variance, enemy_spawner_variance):
		var inst = enemy_spawner.instantiate()
		world.call_deferred("add_child", inst)
		inst.global_position = Vector2(randf_range(barrier_left.position.x, barrier_right.position.x), randf_range(barrier_left.position.y, barrier_right.position.y))
