extends Node

@export var player_objects_to_spawn: Array
@export var enemy_objects_to_spawn: Array
var crate = preload("res://Scenes/Levels/Level Objects/crate_guns.tscn")
var boss = preload("res://Scenes/Enemies/boss_pug.tscn")
var hp_pickup = preload("res://Scenes/Levels/Level Objects/health_pickup.tscn")
var crate_amount_variance: int = 0
var enemy_spawner_variance: int = 0
var starting_crate_amount = 1
var barrier_margin = 80
var barrier_left: Vector2
var barrier_right: Vector2
var boss_round = 20
var spawn_round = 0
var health_rounds: Array[int]


func _ready():
	Globals.level_manager = self
	var level: int = 0
	var world = get_tree().current_scene
	barrier_left = world.get_node("BarrierLeft").position + Vector2(barrier_margin, barrier_margin)
	barrier_right = world.get_node("BarrierRight").position - Vector2(barrier_margin, barrier_margin)
	for i in starting_crate_amount:
		var inst = create_level_object(crate, Vector2(randf_range(-200, 200), randf_range(-100, 100)))
	health_rounds.append(randi_range(4,8))
	health_rounds.append(randi_range(15,19))


func _on_spawn_timeout():
	spawn_round += 1
	for round in health_rounds:
		if spawn_round == round:
			var inst = Globals.create_instance(hp_pickup, get_border_position())
			Globals.ui.add_level_obj(inst.name.to_upper(), true)
	if spawn_round < boss_round:
		for i in randi_range(1, 1 + crate_amount_variance):
			var obj
			if spawn_round <= 3:
				obj = player_objects_to_spawn[0].object_to_spawn
			else:
				obj = player_objects_to_spawn[Globals.get_weighted_index(player_objects_to_spawn)].object_to_spawn
			var inst = create_level_object(obj, get_border_position())
			Globals.ui.add_level_obj(inst.name.to_upper(), true)
		for i in randi_range(1, 1 + enemy_spawner_variance):
			var obj = enemy_objects_to_spawn[Globals.get_weighted_index(enemy_objects_to_spawn)].object_to_spawn
			if obj != null:
				var inst = create_level_object(obj, get_border_position())
				Globals.ui.add_level_obj(inst.name.to_upper(), false)
	else:
		var inst = create_level_object(boss, get_border_position())
		Globals.ui.add_level_obj("Boss!!!", false)
		$Spawn.queue_free()
	Globals.ui.create_level_obj_signs()


func get_border_position() -> Vector2:
	return Vector2(randf_range(barrier_left.x+64, barrier_right.x-64), randf_range(barrier_left.y+64, barrier_right.y-64))


func create_level_object(scene: PackedScene, pos: Vector2) -> Node2D:
	var inst = Globals.create_instance(scene, pos)
	inst.scale = Vector2.ZERO
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(inst, "scale", Vector2.ONE, 1)
	return inst
