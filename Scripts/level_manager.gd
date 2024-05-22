extends Node

@export var crate_amount: Array[int]
@export var enemy_spawner_amount: Array[int]
var crate = preload("res://Scenes/crate.tscn")
var enemy_spawner = preload("res://Scenes/Levels/Level Objects/enemy_spawner_pipe.tscn")
var portal = preload("res://Scenes/Levels/Level Objects/portal.tscn")
var shop = preload("res://Scenes/Levels/Level Objects/shop.tscn")
var crate_amount_variance: int = 1
var enemy_spawner_variance: int = 0
var shop_amount = 1
var barrier_margin = 50
var barrier_left: Vector2
var barrier_right: Vector2
var objects: Array[PackedScene]

func _ready():
	var level: int = 0
	var world = get_tree().current_scene
	barrier_left = world.get_node("BarrierLeft").position + Vector2(barrier_margin, barrier_margin)
	barrier_right = world.get_node("BarrierRight").position - + Vector2(barrier_margin, barrier_margin)
	objects = [crate, enemy_spawner, shop]
	for i in crate_amount[level] + randi_range(-crate_amount_variance, crate_amount_variance):
		var inst = crate.instantiate()
		world.call_deferred("add_child", inst)
		if i == 0:
			inst.global_position = Vector2(randf_range(-300, 300), randf_range(-150, 150))
		else:
			inst.global_position = Vector2(randf_range(barrier_left.x, barrier_right.x), randf_range(barrier_left.y, barrier_right.y))
	#for i in enemy_spawner_amount[level] + randi_range(-enemy_spawner_variance, enemy_spawner_variance):
		#var inst = enemy_spawner.instantiate()
		#world.call_deferred("add_child", inst, Vector2(randf_range(barrier_left.x, barrier_right.x), randf_range(barrier_left.y, barrier_right.y)) )
	#for i in shop_amount:
		#var inst = shop.instantiate()
		#world.call_deferred("add_child", inst, Vector2(randf_range(barrier_left.x, barrier_right.x), randf_range(barrier_left.y, barrier_right.y)) )


func spawn_portal():
	var dis = randf_range(100,200)
	var dir = randf_range(0,360)
	var spawn_point = Globals.player.global_position + (Vector2.RIGHT.rotated(dir) * dis)
	spawn_point = clamp(spawn_point, Vector2(barrier_left.x,barrier_left.y), Vector2(barrier_right.x,barrier_right.y))
	Globals.create_instance(portal, spawn_point)


func _on_spawn_timeout():
	var obj = objects[randi_range(0, objects.size()-1)]
	Globals.player.zoom_out_camera()
	await get_tree().create_timer(1.5).timeout
	Globals.create_instance(obj, Vector2(randf_range(barrier_left.x, barrier_right.x), randf_range(barrier_left.y, barrier_right.y)))
