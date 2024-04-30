extends Control

@export var options: Array[Control]
var current_upgrades: Array[PackedScene]
var current_option: int
var current_gun: int
var has_chosen_upgrade: bool = false
var has_selected: bool = false
var has_finished: bool = false
signal gun_selected(change_int: int)
signal upgrade_assigned


func _ready():
	get_tree().paused = true
	var ui_guns = Globals.world_controller.get_node("CanvasLayer/Guns")
	gun_selected.connect(ui_guns._on_gun_selected)
	upgrade_assigned.connect(ui_guns._on_upgrade_assigned)
	for i in options:
		i.destination = i.position - Vector2(0, 275 + randf_range(20, -20))
	#options[0].select()


func _process(delta):
	if has_finished:
		$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, -100), 5 * delta)
		$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 400), 5 * delta)
	elif has_selected:
		$PositionGuns.position = lerp($PositionGuns.position, Vector2($PositionGuns.position.x, 100), 5 * delta)
		$ReadyButton.position = lerp($ReadyButton.position, Vector2($ReadyButton.position.x, 275), 5 * delta)
	else:
		$ChooseGuns.position = lerp($ChooseGuns.position, Vector2($ChooseGuns.position.x, 100), 5 * delta)
	

func destroy():
	get_tree().paused = false
	await get_tree().create_timer(1.0).timeout
	queue_free()


func move_options():
	has_selected = true
	$ChooseGuns.queue_free()
	for i in options:
		i.destination = i.position - Vector2(0, 350)


func _on_texture_rect_pushed():
	get_tree().paused = false
	has_selected = false
	has_finished = true
	destroy()
