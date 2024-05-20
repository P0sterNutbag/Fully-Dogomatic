extends GunPart

@export var upgrade_folders: Array[String]
@export var unlocked_upgrades: Array[PackedScene]
@export var rarity_chances: Array[int]
var upgrades: Array[SpawnChance] = []
var shop_upgrades: Array[SpawnChance] = []
var master_list: Array[PackedScene] = []


func _ready():
	Globals.upgrade_manager = self
	# create list of all upgrades
	for folder in upgrade_folders:
		master_list += Globals.get_all_scenes_from_folder(folder)
	create_upgrades_list(master_list)


func create_upgrades_list(source_list: Array[PackedScene]):
	for i in source_list.size():
		var inst = source_list[i].instantiate()
		#if unlocked_upgrades.has(source_list[i]):
		add_to_list(upgrades, source_list[i])
		#else:
		#	if inst.is_in_group("gun") or inst.is_in_group("dogtag"):
		#		add_to_list(shop_upgrades, source_list[i])
		var gun_frame = inst.get_node_or_null("GunFrame")
		if gun_frame != null:
			if gun_frame.barrel != null: add_to_list(upgrades, gun_frame.barrel)
			if gun_frame.sight != null: add_to_list(upgrades, gun_frame.sight)
			if gun_frame.stock != null: add_to_list(upgrades, gun_frame.stock)
			if gun_frame.magazine != null: add_to_list(upgrades, gun_frame.magazine)
		inst.queue_free()


func add_to_list(list: Array[SpawnChance], value: PackedScene):
	list.append(SpawnChance.new())
	var new_index = list.size()-1
	list[new_index].object_to_spawn = value
	var inst = value.instantiate()
	list[new_index].spawn_chance = get_spawn_chance(inst.get_meta("Rarity").rarity, inst.name)
	inst.queue_free()


func add_to_upgrade_list(new_upgrade: PackedScene):
	unlocked_upgrades.append(new_upgrade)
	upgrades = []
	shop_upgrades = []
	create_upgrades_list(master_list)


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

