extends UiMenuButton

@export var upgrade_array: Array[String]
@export var show_price: bool
var upgrade
var destination = Vector2.ZERO
var bobbing = false
var mouse_over = false
var price: float = 0
var part_scene = preload("res://Scenes/Upgrades/part_upgrade.tscn")
var gun_upgrade_scene = preload("res://Scenes/Upgrades/gun_upgrade.tscn")
var not_enough_money = preload("res://Scenes/UI/not_enough_money.tscn")


func create_upgrade(upgrade_scene: PackedScene):
	if upgrade != null:
		upgrade.queue_free()
	upgrade = upgrade_scene.instantiate()
	call_deferred("add_child", upgrade)
	upgrade.scale *= 2
	upgrade.position = $GunHolder.position
	$UpgradeName.text = "[center]" + upgrade.get_meta("Title")
	$UpgradeDescription.text = "[center]" + upgrade.get_meta("Type")
	# write price
	if show_price:
		price = round(Globals.get_gun_price(upgrade))
	if price > 0:
		$Price.text = "[center]$" + str(price)


func _process(delta):
	# move away
	if destination != Vector2.ZERO:
		position = lerp(position, destination, 5 * delta)


func _on_pressed():
	if upgrade and Globals.player.money >= price:
		if price > 0:
			Globals.player.spend_money(price)
		if upgrade.name.contains("Dogtag"):
			upgrade.apply_upgrade()
			get_parent().move_options_out()
			Globals.ui.get_node("Dogtags").add_dogtag(upgrade)
			get_parent().finish()
		else: 
			remove_child(upgrade)
			get_tree().current_scene.add_child(upgrade)
			upgrade.call_deferred("attach_to_target", Globals.player)
			upgrade.scale = Vector2.ONE
			upgrade = null
			get_parent().move_options_out()
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
		tween.tween_callback(queue_free)
	else:
		var inst = Globals.create_instance(not_enough_money, global_position + Vector2(77.5, 0), get_parent())
		var tween = create_tween()
		tween.tween_property(inst, "global_position", inst.global_position + Vector2.UP * 12, 1)
		tween.tween_callback(inst.queue_free)


func _exit_tree() -> void:
	var options = get_parent().options
	options.erase(self)
