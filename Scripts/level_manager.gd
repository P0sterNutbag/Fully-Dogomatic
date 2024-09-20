extends Node

@export var drop_round_length: Array[int]
@export var level_items: Array[SpawnChance]
var crate = preload("res://Scenes/Levels/Level Objects/crate_guns.tscn")
var upgrade_crate = preload("res://Scenes/Levels/Level Objects/crate_parts.tscn")
var boss = preload("res://Scenes/Enemies/boss_pug.tscn")
var hp_pickup = preload("res://Scenes/Levels/Level Objects/health_pickup.tscn")
var money_crate = preload("res://Scenes/Levels/Level Objects/money_crate.tscn")
var shop = preload("res://Scenes/Levels/Level Objects/shop.tscn")
var enemy_spawner = preload("res://Scenes/Levels/Level Objects/enemy_spawner_pipe.tscn")
var crate_amount_variance: int = 0
var enemy_spawner_variance: int = 0
var starting_crate_amount = 0
var barrier_margin = 80
var barrier_left: Vector2
var barrier_right: Vector2
var boss_round = 12
var spawn_round = 0
var health_rounds: Array[int]
var spawner_rounds: Array[int]
var crate_max: int = 4


func _ready():
	Globals.level_manager = self
	$Spawn.wait_time = drop_round_length[spawn_round]
	$Spawn.start()
	var level: int = 0
	var world = get_tree().current_scene
	barrier_left = world.get_node("BarrierLeft").position + Vector2(barrier_margin, barrier_margin)
	barrier_right = world.get_node("BarrierRight").position - Vector2(barrier_margin, barrier_margin)
	for i in starting_crate_amount:
		var inst = create_level_object(crate, Vector2(randf_range(-200, 200), randf_range(-100, 100)))
	health_rounds.append(randi_range(3,4))
	health_rounds.append(randi_range(6,8))
	spawner_rounds.append(randi_range(2,4))
	spawner_rounds.append(randi_range(6,8))
	# spawn crates
	var crate_amount = randi_range(2, crate_max)
	for i in crate_amount:
		var spawn_scene = level_items[Globals.get_weighted_index(level_items)].object_to_spawn
		Globals.create_instance(spawn_scene, get_border_position())
		#var inst = create_level_object(money_crate, get_border_position())


func _on_spawn_timeout():
	spawn_round += 1
	$Spawn.wait_time = drop_round_length[spawn_round]
	#$Spawn.start()
	for round in health_rounds:
		if spawn_round == round:
			var inst = Globals.create_instance(hp_pickup, get_border_position())
			Globals.ui.add_level_obj(inst.name.to_upper(), true)
	if spawn_round < boss_round:
		# spawn shop
		var shop_inst = create_level_object(shop, get_border_position())
		Globals.ui.add_level_obj(shop_inst.name.to_upper(), true)
		# spawn pipe
		if spawner_rounds.has(spawn_round):
			var spawner_inst = create_level_object(enemy_spawner, get_border_position())
			Globals.ui.add_level_obj(spawner_inst.name.to_upper(), false)
		# spawn crates
		var crate_amount = randi_range(0, crate_max)
		for i in crate_amount:
			var spawn_scene = level_items[Globals.get_weighted_index(level_items)].object_to_spawn
			var inst = create_level_object(money_crate, get_border_position())
		if crate_amount > 0:
			Globals.ui.add_level_obj("Crate", true, crate_amount)
	else:
		var inst = create_level_object(boss, get_border_position())
		Globals.ui.add_level_obj("Boss!!!", false)
		$Spawn.queue_free()
	Globals.ui.create_level_obj_signs()


func get_border_position() -> Vector2:
	var pos = Vector2(randf_range(barrier_left.x+64, barrier_right.x-64), randf_range(barrier_left.y+64, barrier_right.y-64))
	#$Area2D.global_position = pos
	#while $Area2D.has_overlapping_bodies():
		#pos = Vector2(randf_range(barrier_left.x+64, barrier_right.x-64), randf_range(barrier_left.y+64, barrier_right.y-64))
		#$Area2D.global_position = pos
	return pos


func create_level_object(scene: PackedScene, pos: Vector2) -> Node2D:
	var inst = Globals.create_instance(scene, pos)
	inst.scale = Vector2.ZERO
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(inst, "scale", Vector2.ONE, 1)
	return inst
