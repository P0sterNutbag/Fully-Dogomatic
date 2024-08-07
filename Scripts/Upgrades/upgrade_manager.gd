extends GunPart


@export var rarity_chances: Array[int]
var guns_folder = "res://Scenes/Guns/"
var gunpart_folder = "res://Scenes/Gun Parts/"
var dogtags_folder = "res://Scenes/Upgrades/Dogtags/"
@export var gun_scenes: Array[PackedScene]
@export var gunpart_scenes: Array[PackedScene]
@export var dogtag_scenes: Array[PackedScene]
var guns: Array
var gunparts: Array
var dogtags: Array
var upgrades: Array[SpawnChance] = []
var master_list: Array[PackedScene] = []


func _ready():
	Globals.upgrade_manager = self
	#var gun_scenes: Array = Globals.get_all_scenes_from_folder(guns_folder)
	for gun in gun_scenes:
		add_to_list(guns, gun)
	#var gunpart_scenes: Array = Globals.get_all_scenes_from_folder(gunpart_folder)
	for gunpart in gunpart_scenes:
		add_to_list(gunparts, gunpart)
	#var dogtags_scenes: Array = Globals.get_all_scenes_from_folder(dogtags_folder)
	for dogtag in dogtag_scenes:
		add_to_list(dogtags, dogtag)
	#for folder in upgrade_folders:
		#master_list += Globals.get_all_scenes_from_folder(folder)
	#create_upgrades_list(master_list)


#func create_upgrades_list(source_list: Array[PackedScene]):
	#for i in source_list.size():
		#var inst = source_list[i].instantiate()
		#add_to_list(upgrades, source_list[i])
		#var gun_frame = inst.get_node_or_null("GunFrame")
		#if gun_frame != null:
			#if gun_frame.barrel != null: add_to_list(upgrades, gun_frame.barrel)
			#if gun_frame.sight != null: add_to_list(upgrades, gun_frame.sight)
			#if gun_frame.stock != null: add_to_list(upgrades, gun_frame.stock)
			#if gun_frame.magazine != null: add_to_list(upgrades, gun_frame.magazine)
		#inst.queue_free()


func add_to_list(list: Array, value: PackedScene):
	var sc = SpawnChance.new()
	sc.object_to_spawn = value
	var inst = value.instantiate()
	sc.spawn_chance = get_spawn_chance(inst.get_meta("Rarity").rarity, inst.name)
	list.append(sc)
	inst.queue_free()


func get_spawn_chance(rarity: Globals.rarity_levels, title: String) -> int:
	var multiplier = 1
	if title.contains("Gun"): 
		multiplier = 10
	if rarity == Globals.rarity_levels.common:
		return rarity_chances[0] * multiplier
	elif rarity == Globals.rarity_levels.uncommon:
		return rarity_chances[1] * multiplier
	elif rarity == Globals.rarity_levels.rare:
		return rarity_chances[2] * multiplier
	elif rarity == Globals.rarity_levels.super_rare:
		return rarity_chances[3] * multiplier
	elif rarity == Globals.rarity_levels.ultra_rare:
		return rarity_chances[4] * multiplier
	elif rarity == Globals.rarity_levels.giga_rare:
		return rarity_chances[5] * multiplier
	return 0

