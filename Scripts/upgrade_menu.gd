extends Control

@export var options: Array[Control]
var current_upgrades: Array[PackedScene]
var options_amount = 2
var current_option: int
var has_selected: bool = false
var has_finished: bool = false
var upgrade_array: Array
signal gun_selected(change_int: int)
signal upgrade_assigned


func _ready():
	get_tree().paused = true
	var ui_guns = Globals.world_controller.get_node("CanvasLayer/Guns")
	gun_selected.connect(ui_guns._on_gun_selected)
	upgrade_assigned.connect(ui_guns._on_upgrade_assigned)
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
	
	# close minimap
	#Globals.ui.get_node("Minimap").close_map()


func _process(delta):
	if has_finished:
		$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, -100), 5 * delta)
		$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 400), 5 * delta)
		$CancelButton.position.y = $ReadyButton.position.y
	elif has_selected:
		$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, 100), 5 * delta)
		$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 275), 5 * delta)
	else:
		$CancelButton.position = lerp($CancelButton.position, Vector2($CancelButton.position.x, 275), 5 * delta)
		$ChooseGuns.position = lerp($ChooseGuns.position, Vector2($ChooseGuns.position.x, 100), 5 * delta)
	

func destroy():
	get_tree().paused = false
	#Globals.ui.get_node("Minimap").open_map()
	await get_tree().create_timer(1.0).timeout
	queue_free()


func move_options():
	has_selected = true
	$ChooseGuns.queue_free()
	for i in options:
		if i != null:
			i.destination = Vector2(i.position.x, 500)


func _on_texture_rect_pushed():
	get_tree().paused = false
	has_selected = false
	has_finished = true
	for gun in Globals.player.guns:
		gun.locked = true
	destroy()


func _on_cancel_button_pushed():
	move_options()
	get_tree().paused = false
	has_selected = false
	has_finished = true
	for gun in Globals.player.guns:
		gun.locked = true
	destroy()
