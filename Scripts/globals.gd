extends Node

var player
var crate_spawner
var shoot_sfx
var reload_sfx
var explosion_sfx
var world_controller
var level_manager
var ui_guns
var gunstats
var audio_manager
var ui
var enemy_spawn_controller
var upgrade_manager: Node
var holding_gun_part: bool = false
var settings_open: bool = false
var explode_chance: float = 0
var globals
var barrier_left: Vector2
var barrier_right: Vector2
var camera: Camera2D
enum rarity_levels {common, uncommon, rare, super_rare, ultra_rare, giga_rare }


func _ready():
	globals = self


func create_instance(scene: PackedScene, position: Vector2, parent: Node2D = get_tree().current_scene) -> Node2D:
	if (scene != null):
		var instance = scene.instantiate()
		parent.add_child.call_deferred(instance)
		instance.global_position = position
		return instance
	return null


func generate_circle_points(center: Vector2, radius: float, segments: int) -> Array:
	var points = []
	var angle_increment = 2 * PI / segments
	for i in range(segments):
		var angle = i * angle_increment
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		points.append(Vector2(x, y))
	points.append(points[0])
	return points


func get_weighted_index(array: Array) -> int:
	var sum = 0
	for i in array.size():
		sum += array[i].spawn_chance
	var rand_num = randi_range(0, sum)
	var current_num = 0
	for i in array.size():
		current_num += array[i].spawn_chance
		if rand_num <= current_num:
			return i
	return -1


func activate_gunstats(gun : Node2D):
	gunstats.visible = true
	gunstats.set_stats(gun)


func deactivate_gunstats():
	gunstats.visible = false


func get_all_scenes_from_folder(path: String) -> Array[PackedScene]:
	var dir = DirAccess.open(path)
	var list: Array[PackedScene] = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				pass
			else:
				list.append(load(dir.get_current_dir() + "/" + file_name))
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return list


func get_gun_price(gun) -> float:
	var price: float
	match gun.get_meta("Rarity").rarity:
		rarity_levels.common:
			price = 5 + randf_range(-1, 1)
		rarity_levels.uncommon:
			price = 10 + randf_range(-1, 1)
		rarity_levels.rare:
			price = 20 + randf_range(-2, 2)
		rarity_levels.super_rare:
			price = 30 + randf_range(-2, 2)
		rarity_levels.ultra_rare:
			price = 40 + randf_range(-3, 3)
		rarity_levels.giga_rare:
			price = 50 + randf_range(-3, 3)
	return price
