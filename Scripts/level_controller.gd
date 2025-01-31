extends Node

@export var spawn_formations: Array[SpawnFormation]
@export var level_objects: Array[SpawnChance]
@export var bosses: Array[SpawnChance]
@export var enemy_health = 2.0
@export var enemy_health_incrament = 1.15
@export var spawn_time_incrament = 0.75
var formation_index = 0
var enemies: Array[Enemy]
var bosses_spawned: Array[int]
var round = 0
var hp_round = 4
var boss_round = 1
var pipe_round = 4
var current_kills: int = 0
var shop = preload("res://Scenes/Levels/Level Objects/shop.tscn")
var hp_pickup = preload("res://Scenes/Levels/Level Objects/health_pickup.tscn")
var enemy_spawner = preload("res://Scenes/Levels/Level Objects/enemy_spawner_pipe.tscn")
var final_boss = preload("res://Scenes/Enemies/boss_final.tscn")
@onready var enemy_spawn_timer = $EnemySpawnTimer
@onready var round_timer = $RoundTimer
@onready var enemy_formation_timer = $EnemyFormationTimer
var kills_to_money: int: 
	get:
		return abs(round((60.0 / enemy_spawn_timer.wait_time / 25.0) - Globals.player.money_drop_bonus))


func _ready() -> void:
	Globals.level_manager = self
	for i in 3:
		var spawn_scene = level_objects[Globals.get_weighted_index(level_objects)].object_to_spawn
		var inst = create_level_object(spawn_scene, get_random_position())


func _on_round_timer_timeout() -> void:
	round += 1
	round_timer.wait_time = 60
	round_timer.start()
	enemy_spawn_timer.wait_time = clamp(enemy_spawn_timer.wait_time * spawn_time_incrament, 0.05, 100)
	if enemy_spawn_timer.wait_time < 0.1:
		spawn_time_incrament = 0.9
	enemy_health = max(enemy_health * enemy_health_incrament, 2)
	print("spawn time " + str(enemy_spawn_timer.wait_time))
	print("enemy_health " + str(enemy_health))
	spawn_level_objects()


func _on_enemy_formation_timer_timeout() -> void:
	var last_index = formation_index
	while formation_index == last_index:
		formation_index = randi_range(0, spawn_formations.size()-1)


func _on_enemy_spawn_timer_timeout() -> void:
	spawn_enemy()


func spawn_enemy(enemy_to_spawn: PackedScene = null) -> Node2D:
	if enemies.size() >= 400:
		return
	if enemy_to_spawn == null:
		var index = Globals.get_weighted_index(spawn_formations[formation_index].enemies)
		enemy_to_spawn = spawn_formations[formation_index].enemies[index].object_to_spawn
	#var enemy_to_spawn
	#if !new_enemy:
		#var index = Globals.get_weighted_index(spawn_formations[formation_index].enemies)
		#enemy_to_spawn = Globals.enemy_pool.spawn_enemy(spawn_formations[formation_index].enemies[index].object_to_spawn)
	#else: 
		#enemy_to_spawn = new_enemy.instantiate()
	var spawn_pos: Vector2
	var barrier_left = Globals.world_controller.get_node("BarrierLeft").global_position - Vector2(25, 25)
	var barrier_right = Globals.world_controller.get_node("BarrierRight").global_position + Vector2(25, 25)
	match randi_range(0,3):
		0: spawn_pos = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_left.y)
		1: spawn_pos = Vector2(randf_range(barrier_left.x,barrier_right.x), barrier_right.y)
		2: spawn_pos = Vector2(barrier_left.x, randf_range(barrier_left.y,barrier_right.y))
		3: spawn_pos = Vector2(barrier_right.x, randf_range(barrier_left.y,barrier_right.y))	
	var inst = Globals.create_instance(enemy_to_spawn, spawn_pos)
	inst.position = spawn_pos
	enemies.append(inst)
	if inst is EnemyIncramental:
		inst.health = floor(enemy_health)
	return inst


func spawn_level_objects() -> void:
	# spawn shop
	var shop_inst = create_level_object(shop, get_random_position())
	Globals.ui.add_level_obj(shop_inst.name.to_upper(), true)
	# spawn hp
	if round == hp_round:
		var inst = Globals.create_instance(hp_pickup, get_random_position())
		Globals.ui.add_level_obj(inst.name.to_upper(), true)
		hp_round += 5
	# spawn crates
	var crate_amount = randi_range(1, 4)
	for i in crate_amount:
		var spawn_scene = level_objects[Globals.get_weighted_index(level_objects)].object_to_spawn
		var inst = create_level_object(spawn_scene, get_random_position())
		var hp = inst.get_node("Area2D")
		hp.health *= enemy_health
		hp.max_health = hp.health
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


func reset_kills() -> void:
	current_kills = 0
	kills_to_money += randi_range(-1, 1)


func _on_boss_timer_timeout() -> void:
	if bosses_spawned.size() == 4:
		spawn_enemy(final_boss)
		Globals.ui.add_level_obj("Final Boss!!!", false)
		bosses_spawned.clear()
		return
	var index = Globals.get_weighted_index(bosses)
	while bosses_spawned.has(index):
		index = Globals.get_weighted_index(bosses)
	var boss = bosses[index].object_to_spawn
	var inst = spawn_enemy(boss)
	print(boss.hp)
	bosses_spawned.append(index)
	Globals.ui.add_level_obj("Boss!!!", false)
	Globals.ui.create_level_obj_signs()
