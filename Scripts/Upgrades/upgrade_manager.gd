extends GunPart


@export var rarity_chances: Array[int]
@export var rarity_chances_upgrade: Array[int]
var guns_folder = "res://Scenes/Guns/"
var gunpart_folder = "res://Scenes/Gun Parts/"
var dogtags_folder = "res://Scenes/Upgrades/Dogtags/"
@export var gun_scenes: Array[PackedScene]
@export var upgrades_scenes: Array[PackedScene]
var guns: Array
var common_guns: Array
var uncommon_guns: Array
var rare_guns: Array
var super_rare_guns: Array
var upgrades: Array
var common_upgrades: Array
var uncommon_upgrades: Array
var rare_upgrades: Array
var super_rare_upgrades: Array


func _ready():
	Globals.upgrade_manager = self
	for gun in gun_scenes:
		add_to_list(guns, gun, rarity_chances)
	for upgrade in upgrades_scenes:
		add_to_list(upgrades, upgrade, rarity_chances_upgrade)
	for upgrade in upgrades:
		if upgrade.spawn_chance == rarity_chances_upgrade[0]:
			common_upgrades.append(upgrade)
		elif upgrade.spawn_chance == rarity_chances_upgrade[1]:
			common_upgrades.append(upgrade)
		elif upgrade.spawn_chance == rarity_chances_upgrade[2]:
			rare_upgrades.append(upgrade)
		elif upgrade.spawn_chance == rarity_chances_upgrade[3]:
			super_rare_upgrades.append(upgrade)
	for gun in guns:
		if gun.spawn_chance == rarity_chances[0]:
			common_guns.append(gun)
		elif gun.spawn_chance == rarity_chances[1]:
			uncommon_guns.append(gun)
		elif gun.spawn_chance == rarity_chances[2]:
			rare_guns.append(gun)
		elif gun.spawn_chance == rarity_chances[3]:
			super_rare_guns.append(gun)


func add_to_list(list: Array, value: PackedScene, array: Array):
	var sc = SpawnChance.new()
	sc.object_to_spawn = value
	var inst = value.instantiate()
	sc.spawn_chance = get_spawn_chance(inst.get_meta("Rarity").rarity, array)
	list.append(sc)
	inst.queue_free()


func add_to_list_no_rarity(list: Array, value: PackedScene):
	var sc = SpawnChance.new()
	sc.object_to_spawn = value
	var inst = value.instantiate()
	sc.spawn_chance = 10
	list.append(sc)
	inst.queue_free()


func get_spawn_chance(rarity: Globals.rarity_levels, array: Array) -> int:
	if rarity == Globals.rarity_levels.common:
		return array[0]
	elif rarity == Globals.rarity_levels.uncommon:
		return array[1]
	elif rarity == Globals.rarity_levels.rare:
		return array[2]
	elif rarity == Globals.rarity_levels.super_rare:
		return array[3]
	elif rarity == Globals.rarity_levels.ultra_rare:
		return array[4]
	elif rarity == Globals.rarity_levels.giga_rare:
		return array[5]
	return 0
