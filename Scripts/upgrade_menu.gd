extends Control

@export var options: Array[Control]
var current_upgrades: Array[PackedScene]
var options_amount = 2
var current_option: int
var has_selected: bool = false
var has_finished: bool = false
var upgrade_array: Array
var step = 0
signal gun_selected(change_int: int)
signal upgrade_assigned


func _ready():
	Globals.upgrade_menu = self
	get_tree().paused = true
	var ui_guns = Globals.world_controller.get_node("CanvasLayer/Guns")
	gun_selected.connect(ui_guns._on_gun_selected)
	upgrade_assigned.connect(ui_guns._on_upgrade_assigned)
	if Globals.gun_amount < Globals.player.gun_cap:
		step += 1
		show_options()
	else:
		for gun in Globals.player.guns:
			gun.can_delete = true
			gun.gun_deleted.connect(on_gun_deleted)


func _process(delta):
	match step:
		0:
			get_tree().paused = true
			$CancelButton.position = lerp($CancelButton.position, Vector2($CancelButton.position.x, 275), 5 * delta)
			$RemoveGun.position = lerp($RemoveGun.position, Vector2($RemoveGun.position.x, 100), 5 * delta)
		1:
			get_tree().paused = true
			$RemoveGun.position = lerp($RemoveGun.position, Vector2($RemoveGun.position.x, -100), 5 * delta)
			$CancelButton.position = lerp($CancelButton.position, Vector2($CancelButton.position.x, 275), 5 * delta)
			$ChooseGuns.position = lerp($ChooseGuns.position, Vector2($ChooseGuns.position.x, 100), 5 * delta)
		2:
			get_tree().paused = true
			$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, 100), 5 * delta)
			$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 275), 5 * delta)
		3:
			$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, -100), 5 * delta)
			$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 400), 5 * delta)
			$CancelButton.position.y = $ReadyButton.position.y
	#if has_finished:
		#$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, -100), 5 * delta)
		#$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 400), 5 * delta)
		#$CancelButton.position.y = $ReadyButton.position.y
	#elif has_selected:
		#$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, 100), 5 * delta)
		#$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 275), 5 * delta)
	#else:
		#$CancelButton.position = lerp($CancelButton.position, Vector2($CancelButton.position.x, 275), 5 * delta)
		#$ChooseGuns.position = lerp($ChooseGuns.position, Vector2($ChooseGuns.position.x, 100), 5 * delta)


func destroy():
	#Globals.ui.get_node("Minimap").open_map()
	await get_tree().create_timer(1.0).timeout
	queue_free()


func _exit_tree():
	get_tree().paused = false


func move_options():
	step += 1
	$ChooseGuns.queue_free()
	for i in options:
		if i != null:
			i.destination = Vector2(i.position.x, 500)


func show_options():
	for i in options.size():
		var option = options[i]
		if i <= options_amount - 1:
			option.select_gun()
			option.position.x = (640 / (options_amount + 1)) * (i + 1)
			option.destination = option.position - Vector2(0, 275 + randf_range(20, -20))
		else: 
			option.queue_free()
	for i in options.size():
		if options[i] == null:
			options.remove_at(i)


func on_gun_deleted():
	step += 1
	show_options()
	Globals.ui.set_gun_amount()
	for gun in Globals.player.guns:
		gun.can_delete = false


func _on_texture_rect_pushed():
	get_tree().paused = false
	step += 1
	for gun in Globals.player.guns:
		gun.locked = true
	destroy()


func _on_cancel_button_pushed():
	move_options()
	get_tree().paused = false
	step += 1
	for gun in Globals.player.guns:
		gun.locked = true
	destroy()
