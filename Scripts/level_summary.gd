extends UiMenu

var max_level = 40
var levels: Array = [0]
var current_level: int
var xp: int
var level_unlocks = preload("res://Resources/level_unlocks.tres")
@onready var xp_bar = $Node2D/VBoxContainer/XPBar/ProgressBar
@onready var level_text = $Node2D/VBoxContainer/XPBar/RichTextLabel


func _ready():
	super._ready()
	var total_xp = 0
	var xp_to_level_up = 10
	for i in max_level:
		if i > 0:
			xp_to_level_up *= 1.1
			levels.append(levels[i] + xp_to_level_up)
		else:
			levels.append(10)
	var last_xp = SaveData.xp
	xp = last_xp + Globals.ui.game_time 
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
	if last_xp > 0:
		xp_bar.value = (levels[current_level + 1] - last_xp) / xp_between_levels
	if current_level == last_level:
		level_text.text = "LVL " + str(current_level+1)
		var tween = create_tween().set_ease(Tween.EASE_OUT)
		tween.tween_property(xp_bar, "value", xp_bar_value, 1)
	else:
		level_text.text = "LVL " + str(last_level+1)
		xp_bar.value = (levels[last_level + 1] - last_xp) / xp_between_levels
		var tween = create_tween()
		tween.tween_property(xp_bar, "value", 1, 0.5)
		tween.tween_property(xp_bar, "value", 0, 0)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(level_text, "text", "LVL " + str(current_level+1), 0)
		tween.tween_property(xp_bar, "value", xp_bar_value, 0.5)
	level_unlocks.unlock(current_level)


#func _process(delta: float) -> void:
	#if xp_bar.value >= 1:
		#xp_bar.value = 0
		#SaveData.level = get_new_level()
		#level_text.text = "LVL " + str(SaveData.level)
		#SaveData.save_game()
		#var xp_bar_value = xp / levels[current_level + 1]
		#var tween = create_tween().set_ease(Tween.EASE_OUT)
		#tween.tween_property(xp_bar, "value", xp_bar_value, 1)


func _on_restart_pressed() -> void:
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")


func _on_continue_pressed() -> void:
	get_tree().paused = false
	SceneManager.start_scene_transition(Globals.current_level)


func get_new_level() -> int:
	for i in levels.size():
		if xp <= levels[i]:
			return i-1
	return 1
