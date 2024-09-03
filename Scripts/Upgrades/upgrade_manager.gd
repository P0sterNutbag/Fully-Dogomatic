extends GunPart


@export var rarity_chances: Array[int]
var guns_folder = "res://Scenes/Guns/"
var gunpart_folder = "res://Scenes/Gun Parts/"
var dogtags_folder = "res://Scenes/Upgrades/Dogtags/"
@export var gun_scenes: Array[PackedScene]
@export var upgrades_scenes: Array[PackedScene]
var guns: Array
var upgrades: Array


func _ready():
	Globals.upgrade_manager = self
	for gun in gun_scenes:
		add_to_list(guns, gun)
	for upgrade in upgrades_scenes:
		add_to_list_no_rarity(upgrades, upgrade)


func add_to_list(list: Array, value: PackedScene):
	var sc = SpawnChance.new()
	sc.object_to_spawn = value
	var inst = value.instantiate()
	sc.spawn_chance = get_spawn_chance(inst.get_meta("Rarity").rarity, inst.name)
	list.append(sc)
	inst.queue_free()


func add_to_list_no_rarity(list: Array, value: PackedScene):
	var sc = SpawnChance.new()
	sc.object_to_spawn = value
	var inst = value.instantiate()
	sc.spawn_chance = 10
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
