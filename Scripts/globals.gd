extends Node

var player_to_spawn = preload("res://Scenes/Player/player.tscn")
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
var upgrade_menu: Node
var holding_gun_part: bool = false
var globals
var gun_amount
var current_level: String
var price_multiplier: float:
	get: 
		#return enemy_spawn_controller.spawn_time[enemy_spawn_controller.spawn_round] * 3
		return world_controller.level_controller.enemy_spawn_timer.wait_time
var camera: Camera2D
var muted: bool = false
var pause_controller: Node
var gun_shop = preload("res://Scenes/Upgrades/upgrade_shop.tscn")
var no_guns_shop = preload("res://Scenes/Upgrades/upgrade_shop_no_guns.tscn")
var shop_scene = gun_shop
enum rarity_levels {common, uncommon, rare, super_rare, ultra_rare, giga_rare }


func _ready():
	globals = self
	gun_amount = 0


func create_instance(scene: PackedScene, position: Vector2 = Vector2.ZERO, parent: Node = get_tree().current_scene):
	if (scene != null):
		var instance = scene.instantiate()
		if parent != null:
			parent.add_child.call_deferred(instance)
		if instance is Node2D or instance is Control:
			instance.global_position = position
		return instance
	return null


func get_weighted_index(array) -> int:
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
	var multiplier = price_multiplier
	match gun.get_meta("Rarity").rarity:
		rarity_levels.common:
			price = 3 / multiplier
		rarity_levels.uncommon:
			price = 12 / multiplier
		rarity_levels.rare:
			price = 23 / multiplier
		rarity_levels.super_rare:
			price = 60 / multiplier
		rarity_levels.ultra_rare:
			price = 200 / multiplier
		rarity_levels.giga_rare:
			price = 300 / multiplier
	return price


func time_to_minutes_secs_mili(time : float):
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	var mili = int((time - int(time)) * 100)
	return str("%0*d" % [2, mins]) + ":" + str("%0*d" % [2, secs]) + ":" + str("%0*d" % [2, mili]) 


func scroll_array_index(array: Array, current_index: int, index_change: int) -> int :
	var size = array.size()-1
	current_index += index_change
	if current_index < 0:
		current_index = size
	elif current_index > size:
		current_index = 0
	return current_index
