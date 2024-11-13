extends Node

@export var spawn_formations: Array[SpawnFormation]
var formation_index = 0
var enemies: Array[Enemy]
var enemy_health = 2.0
var enemy_health_incrament = 1.15
var spawn_time_incrament = 0.75
var round = 0
var hp_round = 3
var boss_round = 10
var pipe_round = 4
var enemy_to_spawn = preload("res://Scenes/Enemies/enemy_incramental.tscn")
var boss = preload("res://Scenes/Enemies/boss_1.tscn")
var shop = preload("res://Scenes/Levels/Level Objects/shop.tscn")
var hp_pickup = preload("res://Scenes/Levels/Level Objects/health_pickup.tscn")
var enemy_spawner = preload("res://Scenes/Levels/Level Objects/enemy_spawner_pipe.tscn")
var crate_big = preload("res://Scenes/Levels/Level Objects/money_crate.tscn")
var crate_small = preload("res://Scenes/Levels/Level Objects/barrel.tscn")
var crates = [crate_big, crate_small]
@onready var enemy_spawn_timer = $EnemySpawnTimer


func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	for i in 5:
		spawn_enemy()


func _on_round_timer_timeout() -> void:
	round += 1
	var last_index = formation_index
	while formation_index == last_index:
		formation_index = randi_range(0, spawn_formations.size()-1)
	enemy_spawn_timer.wait_time = enemy_spawn_timer.wait_time * spawn_time_incrament
	if enemy_spawn_timer.wait_time < 0.1:
		spawn_time_incrament = 0.9
	enemy_health = max(enemy_health * enemy_health_incrament, 2)
	print("spawn time " + str(enemy_spawn_timer.wait_time))
	print("enemy_health " + str(enemy_health))
	spawn_level_objects()


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()


func spawn_enemy() -> void:
	if enemies.size() > 300:#get_tree().get_nodes_in_group("enemy").size() > 1000:
		return
		#enemies[150].queue_free()
		#enemies.remove_at(150)
	enemy_to_spawn = spawn_formations[formation_index].enemies[Globals.get_weighted_index(spawn_formations[formation_index].enemies)].object_to_spawn
	var spawn_pos: Vector2
	var barrier_left = Globals.world_controller.get_node("BarrierLeft").global_position - Vector2(25, 25)
	var barrier_right = Globals.world_controller.get_node("BarrierRight").global_position + Vector2(25, 25)
	match randi_range(0,3):
		0: spawn_pos = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_left.y)
		1: spawn_pos = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_right.y)
		2: spawn_pos = Vector2(barrier_left.x, randf_range(barrier_left.y,barrier_right.y))
		3: spawn_pos = Vector2(barrier_right.x, randf_range(barrier_left.y,barrier_right.y))	
	var inst = Globals.create_instance(enemy_to_spawn, spawn_pos)
	enemies.append(inst)
	inst.health = floor(enemy_health)


func spawn_level_objects() -> void:
	# spawn shop
	var shop_inst = create_level_object(shop, get_random_position())
	Globals.ui.add_level_obj(shop_inst.name.to_upper(), true)
	# spawn hp
	if round == hp_round:
		var inst = Globals.create_instance(hp_pickup, get_random_position())
		Globals.ui.add_level_obj(inst.name.to_upper(), true)
		hp_round += randi_range(3, 4)
	## spawn pipe
	#if round == pipe_round:
		#var spawner_inst = create_level_object(enemy_spawner, get_random_position())
		#Globals.ui.add_level_obj(spawner_inst.name.to_upper(), false)
		#pipe_round += randi_range(3, 4)
	# spawn crates
	var crate_amount = randi_range(1, 4)
	for i in crate_amount:
		var spawn_scene = crates[randf_range(0, crates.size())]
		var inst = create_level_object(spawn_scene, get_random_position())
	if round >= boss_round:
		var inst = create_level_object(boss, get_random_position())
		Globals.ui.add_level_obj("Boss!!!", false)
		boss_round += 10
	Globals.ui.create_level_obj_signs()


func create_level_object(scene: PackedScene, pos: Vector2) -> Node2D:
	var inst = Globals.create_instance(scene, pos)
	inst.scale = Vector2.ZERO
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(inst, "scale", Vector2.ONE, 1)
	return inst


func get_random_position() -> Vector2:
	var barrier_left = get_parent().get_node("BarrierLeft").global_position + Vector2.ONE * 80
	var barrier_right = get_parent().get_node("BarrierRight").global_position - Vector2.ONE * 80
	var pos = Vector2(randf_range(barrier_left.x+64, barrier_right.x-64), randf_range(barrier_left.y+64, barrier_right.y-64))
	#$ShapeCast2D.enabled = true
	#$ShapeCast2D.global_position = pos
	#$ShapeCast2D.force_shapecast_update()
	#while $ShapeCast2D.is_colliding():
		#pos = Vector2(randf_range(barrier_left.x+64, barrier_right.x-64), randf_range(barrier_left.y+64, barrier_right.y-64))
		#$ShapeCast2D.global_position = pos
		#$ShapeCast2D.force_shapecast_update()
	#$ShapeCast2D.enabled = false
	return pos
