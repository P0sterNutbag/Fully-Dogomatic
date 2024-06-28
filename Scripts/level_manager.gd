extends Node

@export var player_objects_to_spawn: Array
@export var enemy_objects_to_spawn: Array
var crate = preload("res://Scenes/Levels/Level Objects/crate_guns.tscn")
var portal = preload("res://Scenes/Levels/Level Objects/portal.tscn")
var crate_amount_variance: int = 1
var enemy_spawner_variance: int = 0
var starting_crate_amount = 1
var barrier_margin = 50
var barrier_left: Vector2
var barrier_right: Vector2

func _ready():
	Globals.level_manager = self
	var level: int = 0
	var world = get_tree().current_scene
	barrier_left = world.get_node("BarrierLeft").position + Vector2(barrier_margin, barrier_margin)
	barrier_right = world.get_node("BarrierRight").position - + Vector2(barrier_margin, barrier_margin)
	for i in starting_crate_amount:
		var inst = crate.instantiate()
		world.call_deferred("add_child", inst)
		if i == 0:
			inst.global_position = Vector2(randf_range(-300, 300), randf_range(-150, 150))
		else:
			inst.global_position = Vector2(randf_range(barrier_left.x, barrier_right.x), randf_range(barrier_left.y, barrier_right.y))


func spawn_portal():
	var dis = randf_range(100,200)
	var dir = randf_range(0,360)
	var spawn_point = Globals.player.global_position + (Vector2.RIGHT.rotated(dir) * dis)
	spawn_point = clamp(spawn_point, Vector2(barrier_left.x,barrier_left.y), Vector2(barrier_right.x,barrier_right.y))
	Globals.create_instance(portal, spawn_point)


func _on_spawn_timeout():
	for i in randi_range(1, 2):
		var obj = player_objects_to_spawn[Globals.get_weighted_index(player_objects_to_spawn)].object_to_spawn
		var inst = Globals.create_instance(obj, Vector2(randf_range(barrier_left.x, barrier_right.x), randf_range(barrier_left.y, barrier_right.y)))
		Globals.ui.add_level_obj(inst.name.to_upper())
	for i in randi_range(1, 2):
		var obj = enemy_objects_to_spawn[Globals.get_weighted_index(enemy_objects_to_spawn)].object_to_spawn
		var inst = Globals.create_instance(obj, Vector2(randf_range(barrier_left.x, barrier_right.x), randf_range(barrier_left.y, barrier_right.y)))
		Globals.ui.add_level_obj(inst.name.to_upper())
	Globals.ui.create_level_obj_signs()
