extends UiMenuButton

@export var upgrade_array: Array[String]
@export var show_price: bool
var upgrade
var destination = Vector2.ZERO
var bobbing = false
var mouse_over = false
var price: float = 0
var upgrade_scene
var part_scene = preload("res://Scenes/Upgrades/part_upgrade.tscn")
var gun_upgrade_scene = preload("res://Scenes/Upgrades/gun_upgrade.tscn")
var not_enough_money = preload("res://Scenes/UI/not_enough_money.tscn")


func create_upgrade(scene: PackedScene):
	if upgrade != null:
		upgrade.queue_free()
	upgrade = scene.instantiate()
	upgrade_scene = scene
	call_deferred("add_child", upgrade)
	upgrade.scale *= 2
	upgrade.position = $GunHolder.position
	$UpgradeName.text = "[center]" + (upgrade.get_meta("Title")).to_upper()
	$UpgradeDescription.text = "[center]" + (upgrade.get_meta("Type")).to_upper()
	# write price
	if show_price:
		calculate_price()


func calculate_price():
	# write price
	price = floor(Globals.get_gun_price(upgrade) * (1 - Globals.player.shop_discount))
	$Price.text = "[center]$" + str(price)


func _process(delta):
	# move away
	if destination != Vector2.ZERO:
		position = lerp(position, destination, 5 * delta)


func _on_pressed():
	if !upgrade:
		return 
	if Globals.player.guns.size() >= Globals.player.gun_cap and upgrade is Gun:
		var inst = Globals.create_instance(not_enough_money, global_position + Vector2(77.5, 0), get_parent())
		inst.get_child(0).text = "GUN CAP REACHED!"
	elif Globals.player.money >= price:
		if price > 0:
			Globals.player.spend_money(price)
		if upgrade is Dogtag:
			upgrade.apply_upgrade()
			#Globals.upgrade_menu.move_options_out()
			Globals.ui.get_node("Dogtags").add_dogtag(upgrade)
			Globals.upgrade_menu.upgrade_to_delete = null
			Globals.upgrade_menu.finish(0.3)
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ZERO, 0.25) 
			tween.tween_callback(queue_free)
		else: 
			remove_child(upgrade)
			get_tree().current_scene.add_child(upgrade)
			upgrade.call_deferred("attach_to_target", Globals.player)
			upgrade.scale = Vector2.ONE
			Globals.upgrade_menu.move_options_out()
			if upgrade is Gun:
				Globals.upgrade_menu.place_text.text = "[center]PLACE\nYOUR GUN!"
			else:
				Globals.upgrade_menu.place_text.text = "[center]CHOOSE A GUN TO UPGRADE!"
			upgrade = null
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
			Globals.upgrade_menu.upgrade_to_delete = self
			#tween.tween_callback(queue_free)
	else:
		var inst = Globals.create_instance(not_enough_money, global_position + Vector2(77.5, 0), get_parent())


func _exit_tree() -> void:
	var options = Globals.upgrade_menu.options
	options.erase(self)


func _on_focus_entered() -> void:
	$JuicyMovement.process_mode = Node.PROCESS_MODE_INHERIT
	if upgrade and upgrade.get_meta("Type") != "":
		Globals.upgrade_menu.show_tooltip(global_position + pivot_offset + Vector2.DOWN * 72, upgrade.get_meta("Type"))


func _on_focus_exited() -> void:
	$JuicyMovement.process_mode = Node.PROCESS_MODE_DISABLED
	rotation_degrees = 0
	Globals.upgrade_menu.hide_tooltip()
