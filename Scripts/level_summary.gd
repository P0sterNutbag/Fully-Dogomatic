extends UiMenu

var max_level = 40
var levels: Array = [0]
var current_level: int
var xp: int
var level_unlocks = preload("res://Resources/level_unlocks.tres")
var unlock_alert_scene = preload("res://Scenes/UI/unlock_alert.tscn")
var unlock_alert: Control
@onready var buttons = $Node2D/Buttons
@onready var xp_bar = $Node2D/VBoxContainer/XPBar/ProgressBar
@onready var level_text = $Node2D/VBoxContainer/XPBar/RichTextLabel
@onready var time_text = $Node2D/VBoxContainer/Time
@onready var kills_text = $Node2D/VBoxContainer/Kills
@onready var guns_text = $Node2D/VBoxContainer/Guns
@onready var upgrades_text = $Node2D/VBoxContainer/Upgrades


func _ready():
	super._ready()
	buttons.visible = false
	var total_xp = 0
	var xp_to_level_up = 10
	for i in max_level:
		if i > 0:
			xp_to_level_up *= 1.1
			levels.append(levels[i] + xp_to_level_up)
		else:
			levels.append(10)
	var last_xp = SaveData.xp
	xp = last_xp + Globals.ui.game_time# / 60
	var last_level = SaveData.level
	current_level = get_new_level()
	SaveData.level = current_level
	var time = Globals.time_to_minutes_secs_mili(Globals.ui.game_time)
	match Globals.world_controller.name:
		"World 1":
			SaveData.stage0time = time
		"World 2":
			SaveData.stage1time = time
		"World 2":
			SaveData.stage2time = time
	SaveData.xp = xp
	SaveData.save_game()
	# animate xp bar
	var xp_to_next_level = levels[current_level + 1] - xp
	var xp_between_levels = levels[current_level + 1] - levels[current_level]
	var xp_bar_value = float((xp_between_levels - xp_to_next_level)) / float(xp_between_levels)
	var tween = create_tween()
	if last_xp > 0 and xp > 0:
		xp_bar.value = float((levels[current_level + 1] - last_xp)) / float(xp_between_levels)
	else:
		xp_bar.value = 0
	if current_level == last_level:
		level_text.text = "LVL " + str(current_level+1)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(xp_bar, "value", xp_bar_value, 1)
	else:
		level_text.text = "LVL " + str(last_level+1)
		xp_bar.value = (levels[last_level + 1] - last_xp) / xp_between_levels
		tween.tween_property(xp_bar, "value", 1, 0.5)
		tween.tween_property(xp_bar, "value", 0, 0)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(level_text, "text", "LVL " + str(current_level+1), 0)
		tween.tween_property(xp_bar, "value", xp_bar_value, 0.5)
	await tween.finished
	# create unlock notifications
	for i in range(0, level_unlocks.unlock(last_level, current_level)):
		unlock_alert = Globals.create_instance(unlock_alert_scene, Vector2(240, 180), self)
		var txt = "[center]" + level_unlocks.names[level_unlocks.unlocks_array[last_level + 1 + i]].to_upper() + " UNLOCKED"
		var texture = level_unlocks.pics[level_unlocks.unlocks_array[last_level + 1 + i]]
		unlock_alert.get_node("RichTextLabel").text = txt
		unlock_alert.get_node("Sprite2D").texture = texture
		await unlock_alert.tree_exited
	var tween2 = create_tween()
	# animate stats
	tween2.tween_property(time_text, "text", "TIME: " + time, 0.25)
	tween2.tween_property(kills_text, "text", "KILLS: " + str(Globals.world_controller.total_kills), 0.25)
	tween2.tween_callback(activate_buttons)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		if unlock_alert:
			var tween = create_tween().set_ease(Tween.EASE_IN)
			tween.tween_property(unlock_alert, "scale", Vector2.ZERO, 0.25)
			tween.tween_callback(unlock_alert.queue_free)
			unlock_alert = null


func activate_buttons() -> void:
	buttons.visible = true
	buttons.process_mode = Node.PROCESS_MODE_INHERIT
	first_button.grab_focus()


func _on_restart_pressed() -> void:
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")


func _on_continue_pressed() -> void:
	get_tree().paused = false
	SceneManager.start_scene_transition(Globals.current_level)


func get_new_level() -> int:
	for i in levels.size():
		if xp < levels[i]:
			return i-1
	return 1
