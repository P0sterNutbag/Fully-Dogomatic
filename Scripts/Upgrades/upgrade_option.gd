extends Control

@export var options = []
@export var is_shop_option: bool = false
var option
var upgrade
var destination = Vector2.ZERO
var bobbing = false
var mouse_over = false
var selected: bool = false
var part_scene = preload("res://Scenes/Upgrades/part_upgrade.tscn")


func _ready():
	# get the upgrade list from the manager
	if !is_shop_option:
		options = Globals.upgrade_manager.upgrades
	else:
		options = Globals.upgrade_manager.shop_upgrades
	# get an option and make sure it isn't already used
	var rand_index = Globals.get_weighted_index(options)
	var upgrade_menu = get_parent()
	while upgrade_menu.current_upgrades.has(options[rand_index].object_to_spawn):
		rand_index = Globals.get_weighted_index(options)
	option = options[rand_index]
	upgrade_menu.current_upgrades.append(option.object_to_spawn)
	upgrade = option.object_to_spawn.instantiate()
	if !upgrade.name.contains("Gun") and !upgrade.name.contains("Dogtag"):
		upgrade.queue_free()
		upgrade = part_scene.instantiate()
		upgrade.part = option.object_to_spawn
		upgrade.set_sprite()
	add_child(upgrade)
	upgrade.scale *= 2
	$UpgradeName.text = "[center]" + upgrade.get_meta("Title")
	$UpgradeDescription.text = "[center]" + upgrade.get_meta("Type")


func _process(delta):
	# move away
	if destination != Vector2.ZERO:
		position = lerp(position, destination, 5 * delta)
	
	if position.distance_to(get_global_mouse_position()) < $Circle.circle_radius and !selected:
		scale = lerp(scale, Vector2.ONE * 1.25, 5 * delta)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if upgrade:
				selected = true
				if is_shop_option:
					Globals.upgrade_manager.add_to_upgrade_list(option.object_to_spawn)
				if upgrade.name.contains("Dogtag"):
					upgrade.apply_upgrade()
					get_parent().move_options()
					get_parent()._on_texture_rect_pushed()
					#remove_child(upgrade)
					Globals.ui.get_node("Dogtags").add_dogtag(upgrade)
				else: 
					upgrade.follow_mouse = true
					remove_child(upgrade)
					get_tree().current_scene.add_child(upgrade)
					upgrade.attach_to_target(Globals.player)
					upgrade.scale = Vector2.ONE
					upgrade = null
					get_parent().move_options()
	else:
		scale = lerp(scale, Vector2.ONE, 5 * delta)


func apply_to_upgrade(_upgrade: Node2D):
	var instance = option.object_to_spawn.instantiate()
	_upgrade.add_child(instance)


func select():
	scale *= 1.35
	bobbing = true
	z_index += 1


func unselect():
	scale = Vector2(1, 1)
	bobbing = false
	z_index -= 1

