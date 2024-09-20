extends Control

@export var options: Array[Control]
var upgrades: Array
var options_amount = 2
var current_option: int
var has_selected: bool = false
var has_finished: bool = false
var upgrade_array: Array
var step = 0
var upgrades_spawned: int = 0
var random_upgrades: bool = true
signal gun_selected(change_int: int)
signal upgrade_assigned
@onready var cancel_button = $Cancel
@onready var accept_button = $Accept


func _ready():
	Globals.upgrade_menu = self
	get_tree().paused = true
	if Globals.gun_amount < Globals.player.gun_cap:
		step += 1
		show_options()
	else:
		for gun in Globals.player.guns:
			gun.can_delete = true
			gun.gun_deleted.connect(on_gun_deleted)
	options[0].grab_focus()
	if upgrades.size() > 0:
		random_upgrades = false


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and step < 2:
		queue_free()
	match step:
		0:
			get_tree().paused = true
			$RemoveGun.position = lerp($RemoveGun.position, Vector2($RemoveGun.position.x, 100), 5 * delta)
		1:
			get_tree().paused = true
			$RemoveGun.position = lerp($RemoveGun.position, Vector2($RemoveGun.position.x, -100), 5 * delta)
			#cancel_button.position = lerp(cancel_button.position, Vector2(cancel_button.position.x, 275), 5 * delta)
			$ChooseGuns.position = lerp($ChooseGuns.position, Vector2($ChooseGuns.position.x, 100), 5 * delta)
		2:
			get_tree().paused = true
			$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, 100), 5 * delta)
			#accept_button.position = lerp(accept_button.position, Vector2(accept_button.position.x, 275), 5 * delta)
			#cancel_button.position.y = accept_button.position.y
		3:
			$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, -100), 5 * delta)
			#accept_button.position = lerp(accept_button.position, Vector2(accept_button.position.x, 400), 5 * delta)
			#cancel_button.position.y = accept_button.position.y


func show_options():
	for i in options.size():
		var option = options[i]
		if i <= options_amount - 1:
			# select gun
			if random_upgrades:
				var rand_index = Globals.get_weighted_index(upgrade_array)
				while upgrades.has(upgrade_array[rand_index].object_to_spawn):
					rand_index = Globals.get_weighted_index(upgrade_array)
				option.option = upgrade_array[rand_index]
				upgrades.append(upgrade_array[rand_index].object_to_spawn)
			else:
				option.option = upgrades[upgrades_spawned]
				upgrades_spawned += 1
			option.select_gun()
			option.position.x = (640 / (options_amount + 1)) * (i + 1) - (option.size.x / 2)
			option.destination = option.position - Vector2(0, 330 + randf_range(20, -20))
		else: 
			option.queue_free()
	for i in options.size():
		if options[i] == null:
			options.remove_at(i)


func destroy():
	queue_free()


func _exit_tree():
	get_tree().paused = false


func move_options():
	step += 1
	if $ChooseGuns != null:
		$ChooseGuns.queue_free()
	for i in options:
		if i != null:
			i.destination = Vector2(i.position.x, 500)
			i.focus_mode = Control.FOCUS_NONE


func on_gun_deleted():
	step += 1
	show_options()
	Globals.ui.set_gun_amount()
	for gun in Globals.player.guns:
		gun.can_delete = false


func _on_button_pressed():
	move_options()
	get_tree().paused = false
	step += 1
	for gun in Globals.player.guns:
		gun.locked = true
	destroy()


func _on_accept_pressed():
	finish()


func finish():
	move_options()
	step = 2
	#get_tree().paused = false
	#step += 1
	#for gun in Globals.player.guns:
		#gun.locked = true
	#destroy()
