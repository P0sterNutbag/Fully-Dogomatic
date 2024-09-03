extends UiMenuButton

var option
var upgrade
var destination = Vector2.ZERO
var bobbing = false
var mouse_over = false
var selected: bool = false
var price: float = 0
var show_price: bool = false
var part_scene = preload("res://Scenes/Upgrades/part_upgrade.tscn")
var gun_upgrade_scene = preload("res://Scenes/Upgrades/gun_upgrade.tscn")


func select_gun():
	# get an option and make sure it isn't already used
	var upgrade_menu = get_parent()
	var rand_index = Globals.get_weighted_index(upgrade_menu.upgrade_array)
	while upgrade_menu.current_upgrades.has(upgrade_menu.upgrade_array[rand_index].object_to_spawn):
		rand_index = Globals.get_weighted_index(upgrade_menu.upgrade_array)
	option = upgrade_menu.upgrade_array[rand_index]
	upgrade_menu.current_upgrades.append(option.object_to_spawn)
	upgrade = option.object_to_spawn.instantiate()
	call_deferred("add_child", upgrade)
	upgrade.scale *= 2
	upgrade.position = $GunHolder.position
	$UpgradeName.text = "[center]" + upgrade.get_meta("Title")
	$UpgradeDescription.text = "[center]" + upgrade.get_meta("Type")
	# write price
	if show_price:
		price = round(Globals.get_gun_price(upgrade)*pow(10,2))/pow(10,2)
	if price > 0:
		$Price.text = "[center]$" + str(price)


func _process(delta):
	# move away
	if destination != Vector2.ZERO:
		position = lerp(position, destination, 5 * delta)
	
	#if position.distance_to(get_global_mouse_position()) < $Circle.circle_radius and !selected:
		#scale = lerp(scale, Vector2.ONE * 1.25, 5 * delta)
		#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#if upgrade and Globals.player.money >= price:
				#selected = true
				#if price > 0:
					#Globals.player.spend_money(price)
				#if upgrade.name.contains("Dogtag"):
					#upgrade.apply_upgrade()
					#get_parent().move_options()
					#get_parent()._on_texture_rect_pushed()
					##remove_child(upgrade)
					#Globals.ui.get_node("Dogtags").add_dogtag(upgrade)
				#else: 
					#upgrade.follow_mouse = true
					#remove_child(upgrade)
					#get_tree().current_scene.add_child(upgrade)
					#upgrade.call_deferred("attach_to_target", Globals.player)
					#upgrade.scale = Vector2.ONE
					#upgrade = null
					#get_parent().move_options()
	#else:
	#	scale = lerp(scale, Vector2.ONE, 5 * delta)


func apply_to_upgrade(_upgrade: Node2D):
	var instance = option.object_to_spawn.instantiate()
	_upgrade.add_child(instance)


#func select():
	#scale *= 1.35
	#bobbing = true
	#z_index += 1
#
#
#func unselect():
	#scale = Vector2(1, 1)
	#bobbing = false
	#z_index -= 1


#func _on_color_rect_gui_input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#if upgrade and Globals.player.money >= price:
			#selected = true
			#if price > 0:
				#Globals.player.spend_money(price)
			#if upgrade.name.contains("Dogtag"):
				#upgrade.apply_upgrade()
				#get_parent().move_options()
				#get_parent()._on_texture_rect_pushed()
				##remove_child(upgrade)
				#Globals.ui.get_node("Dogtags").add_dogtag(upgrade)
			#else: 
				#remove_child(upgrade)
				#get_tree().current_scene.add_child(upgrade)
				#upgrade.call_deferred("attach_to_target", Globals.player)
				#upgrade.scale = Vector2.ONE
				#upgrade = null
				#get_parent().move_options()


#func _on_color_rect_mouse_entered():
	#var tween = create_tween().set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "scale", Vector2.ONE * 1.25, 0.2)
#
#
#func _on_color_rect_mouse_exited():
	#var tween = create_tween().set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "scale", Vector2.ONE, 0.2)


func _on_pressed():
	if upgrade and Globals.player.money >= price:
		selected = true
		if price > 0:
			Globals.player.spend_money(price)
		if upgrade.name.contains("Dogtag"):
			upgrade.apply_upgrade()
			get_parent().move_options()
			get_parent().finish()
			#remove_child(upgrade)
			Globals.ui.get_node("Dogtags").add_dogtag(upgrade)
		else: 
			remove_child(upgrade)
			get_tree().current_scene.add_child(upgrade)
			upgrade.call_deferred("attach_to_target", Globals.player)
			upgrade.scale = Vector2.ONE
			upgrade = null
			get_parent().move_options()


#func _on_focus_entered():
	#var tween = create_tween().set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "scale", Vector2.ONE * 1.25, 0.2)
#
#
#func _on_focus_exited():
	#var tween = create_tween().set_trans(Tween.TRANS_SINE)
	#tween.tween_property(self, "scale", Vector2.ONE, 0.2)
