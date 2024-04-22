extends Control

@export var options = []
@export var upgrades: Array
var option
var upgrade
var destination = Vector2.ZERO
var bobbing = false
var gun
var mouse_over = false


func _ready():
	# get an option and make sure it isn't already used
	var upgrade_menu = get_parent()
	var rand_index = Globals.get_random_index(options)
	while upgrade_menu.current_upgrades.has(options[rand_index].object_to_spawn):
		rand_index = Globals.get_random_index(options)
	option = options[rand_index]
	upgrade_menu.current_upgrades.append(option.object_to_spawn)
	gun = option.object_to_spawn.instantiate()
	add_child(gun)
	gun.scale *= 2
	$UpgradeName.text = "[center]" + gun.get_meta("Title")
	$UpgradeDescription.text = "[center]" + gun.get_meta("Type")


func _process(delta):
	# move away
	if destination != Vector2.ZERO:
		position = lerp(position, destination, 5 * delta)
		
	if position.distance_to(get_global_mouse_position()) < $Circle.circle_radius:
		scale = lerp(scale, Vector2.ONE * 1.25, 5 * delta)
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if gun:
				gun.follow_mouse = true
				remove_child(gun)
				get_tree().current_scene.add_child(gun)
				gun.attach_to_target(Globals.player)
				gun.scale = Vector2.ONE
				gun = null
				get_parent().move_options()
	else:
		scale = lerp(scale, Vector2.ONE, 5 * delta)


func apply_to_gun(_gun: Node2D):
	var instance = option.object_to_spawn.instantiate()
	_gun.add_child(instance)


func spawn_upgrade():
	pass
	#Globals.crate_spawner.spawn_crate(upgrade_object, option.object_to_spawn)


func spawn_gun():
	Globals.crate_spawner.spawn_crate(option.object_to_spawn)	


func select():
	scale *= 1.35
	bobbing = true
	z_index += 1


func unselect():
	scale = Vector2(1, 1)
	bobbing = false
	z_index -= 1







# THIS USED TO BE IN READY
#upgrade_instance.scale *= 2
	#var source_sprite
	## get upgrade info
	#if upgrade_instance.name.contains("Upgrade"):
		#source_sprite = Sprite2D.new()
		#source_sprite.texture = upgrade_sprite
		#$UpgradeName.text = "[center]" + "Upgrade"
		#$UpgradeDescription.text = "[center]" + upgrade_instance.get_meta("Title")
	#else:
		#if upgrade_instance.get_node("GunFrame") != null:
			#var frame = gun_frame.instantiate()
			#add_child(frame)
			#frame.global_position = $UpgradeIcon.global_position
			#frame.scale *= 2
			#var gun_inst = upgrade_instance.get_node("GunFrame")
			#frame.copy_parts(gun_inst)
		##source_sprite = upgrade_instance.get_node("Sprite2D")
		#$UpgradeName.text = "[center]" + upgrade_instance.get_meta("Title")
		#$UpgradeDescription.text = "[center]" + upgrade_instance.get_meta("Type")
	##$UpgradeIcon.texture = source_sprite.texture
	##$UpgradeIcon.region_enabled = source_sprite.region_enabled
	##$UpgradeIcon.region_rect = source_sprite.region_rect
	#upgrade_instance.queue_free()
