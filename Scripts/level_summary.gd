extends UiMenu

var max_level = 40
var levels: Array = [0]
var current_level: int
var xp: int
var level_unlocks = preload("res://Resources/level_unlocks.tres")
var alert_scene = preload("res://Scenes/UI/unlock_alert.tscn")
var unlock_alert: Control
@onready var buttons = $Node2D/Buttons
@onready var xp_bar = $Node2D/VBoxContainer/XPBar/ProgressBar
@onready var level_text = $Node2D/VBoxContainer/XPBar/RichTextLabel
@onready var time_text = $Node2D/VBoxContainer/Time2
@onready var best_time_text = $Node2D/VBoxContainer/BestTime2
@onready var new_record = $Node2D/RichTextLabel2


func _ready():
	get_tree().paused = true
	super._ready()
	buttons.visible = false
	best_time_text.text = "[center]" + Globals.time_to_minutes_secs_mili(SaveData.best_time)
	var time = Globals.time_to_minutes_secs_mili(Globals.ui.game_time)
	if Globals.ui.game_time > SaveData.best_time:
		SaveData.best_time = Globals.ui.game_time
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	# animate stats
	tween.tween_property(time_text, "text", "[center]" + time, 1)
	await tween.finished
	var alerts = unlock_characters()
	for alert in alerts:
		add_child(alert)
		await alert.tree_exited
	activate_buttons()
	best_time_text.text = "[center]" + Globals.time_to_minutes_secs_mili(SaveData.best_time)
	if time_text.text == best_time_text.text:
		new_record.show()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if unlock_alert:
			var tween = create_tween().set_ease(Tween.EASE_IN)
			tween.tween_property(unlock_alert, "scale", Vector2.ZERO, 0.25)
			tween.tween_callback(unlock_alert.queue_free)
			unlock_alert = null


func unlock_characters() -> Array:
	var unlocked_characters: Array
	if !SaveData.character1 and Globals.world_controller.bosses_killed >= 1:
		unlocked_characters.append(1)
		SaveData.character1 = true
		Globals.set_achievement("unlock_a_character")
	if !SaveData.character2 and Globals.world_controller.bosses_killed >= 2:
		unlocked_characters.append(2)
		SaveData.character2 = true
	if !SaveData.character3 and Globals.world_controller.bosses_killed >= 3:
		unlocked_characters.append(3)
		SaveData.character3 = true
	var alerts: Array
	for i in unlocked_characters:
		var inst = alert_scene.instantiate()
		alerts.append(inst)
		inst.position = size / 2
		inst.set_character(i)
		SaveData.save_game()
	return alerts


func activate_buttons() -> void:
	buttons.visible = true
	buttons.process_mode = Node.PROCESS_MODE_INHERIT
	first_button.grab_focus()


func _on_restart_pressed() -> void:
	get_tree().paused = false
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")


func _on_continue_pressed() -> void:
	get_tree().paused = false
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")


func get_new_level() -> int:
	for i in levels.size():
		if xp < levels[i]:
			return i-1
	return 1
