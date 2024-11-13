extends Node

@export var drop_round_length: Array[int]
@export var level_items: Array[SpawnChance]
@export var enemies: Array[SpawnChanceAmount]
@export var boss: PackedScene
var hp_pickup = preload("res://Scenes/Levels/Level Objects/health_pickup.tscn")
var money_crate = preload("res://Scenes/Levels/Level Objects/money_crate.tscn")
var shop = preload("res://Scenes/Levels/Level Objects/shop.tscn")
var enemy_spawner = preload("res://Scenes/Levels/Level Objects/enemy_spawner_pipe.tscn")
var enemy_reinforcement = preload("res://Scenes/Enemies/enemy_reinforcement.tscn")
var enemy_spawner_variance: int = 0
var barrier_margin = 80
var boss_round: int
var spawn_round = 0
var health_rounds: Array[int]
var spawner_rounds: Array[int]
var enemy_rounds: Array[int]
var crate_max: int = 4
var overlapping_spawn: bool


func _ready():
	Globals.level_manager = self
	$Spawn.wait_time = drop_round_length[spawn_round]
	$Spawn.start()
	boss_round = drop_round_length.size() - 1
	var level: int = 0
	var world = get_tree().current_scene
	health_rounds.append(randi_range(2,4))
	spawner_rounds.append(randi_range(2,4))
	#enemy_rounds.append(2)
	#enemy_rounds.append(4)
	#enemy_rounds.append(6)
	#enemy_rounds.append(8)
	#enemy_rounds.append(10)
	# spawn crates
	var crate_amount = randi_range(2, crate_max)
	for i in crate_amount:
		var spawn_scene = level_items[Globals.get_weighted_index(level_items)].object_to_spawn
		Globals.create_instance(spawn_scene, get_border_position())
		#var inst = create_level_object(money_crate, get_border_position())


func _on_spawn_timeout():
	spawn_level_objects()


func spawn_level_objects() -> void:
	if spawn_round > boss_round:
		return
	spawn_round += 1
	Globals.enemy_spawn_controller.spawn_round += 1
	$Spawn.wait_time = drop_round_length[spawn_round]
	#$Spawn.start()
	if spawn_round < boss_round:
		# spawn shop
		var shop_inst = create_level_object(shop, get_border_position())
		Globals.ui.add_level_obj(shop_inst.name.to_upper(), true)
		# spawn hp
		for round in health_rounds:
			if spawn_round == round:
				var inst = Globals.create_instance(hp_pickup, get_border_position())
				Globals.ui.add_level_obj(inst.name.to_upper(), true)
		# spawn pipe
		if spawner_rounds.has(spawn_round):
			var spawner_inst = create_level_object(enemy_spawner, get_border_position())
			Globals.ui.add_level_obj(spawner_inst.name.to_upper(), false)
		# spawn enemies
		if enemy_rounds.has(spawn_round):
			var inst = create_level_object(enemy_reinforcement, get_border_position())
			var index = randi_range(0, enemies.size()-1)
			inst.enemy_to_spawn = enemies[index].object_to_spawn
			inst.amount_to_spawn = enemies[index].amount
			Globals.ui.add_level_obj(inst.name.to_upper(), false)
		# spawn crates
		var crate_amount = randi_range(0, crate_max)
		for i in crate_amount:
			var spawn_scene = level_items[Globals.get_weighted_index(level_items)].object_to_spawn
			var inst = create_level_object(spawn_scene, get_border_position())
		#if crate_amount > 0:
			#Globals.ui.add_level_obj("CRATE", true, crate_amount)
	else:
		var inst = create_level_object(boss, get_border_position())
		Globals.ui.add_level_obj("Boss!!!", false)
		$Spawn.queue_free()
	Globals.ui.create_level_obj_signs()


func get_border_position() -> Vector2:
	var barrier_left = get_parent().get_node("BarrierLeft").global_position + Vector2(barrier_margin, barrier_margin)
	var barrier_right = get_parent().get_node("BarrierRight").global_position - Vector2(barrier_margin, barrier_margin)
	var pos = Vector2(randf_range(barrier_left.x+64, barrier_right.x-64), randf_range(barrier_left.y+64, barrier_right.y-64))
	$ShapeCast2D.enabled = true
	$ShapeCast2D.global_position = pos
	$ShapeCast2D.force_shapecast_update()
	while $ShapeCast2D.is_colliding():
		pos = Vector2(randf_range(barrier_left.x+64, barrier_right.x-64), randf_range(barrier_left.y+64, barrier_right.y-64))
		$ShapeCast2D.global_position = pos
		$ShapeCast2D.force_shapecast_update()
	$ShapeCast2D.enabled = false
	return pos


func create_level_object(scene: PackedScene, pos: Vector2) -> Node2D:
	var inst = Globals.create_instance(scene, pos)
	inst.scale = Vector2.ZERO
	var tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(inst, "scale", Vector2.ONE, 1)
	return inst
