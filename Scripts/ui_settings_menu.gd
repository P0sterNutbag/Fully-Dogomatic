extends Control

var last_focus_owner: Control
var current_menu
var menus: Array[Control]
var sfx_volume
var music_volume
@onready var pause_menu = $Menu/VBoxContainer
@onready var settings_menu = $Menu/VBoxContainer2
@onready var sfx_volume_slider = $Menu/VBoxContainer2/SFXVolume/SFXVolSlider
@onready var music_volume_slider = $Menu/VBoxContainer2/MusicVolume/MusicVolSlider
@onready var windowed_mode_text = $Menu/VBoxContainer2/WindowMode/Label



func _ready():
	sfx_volume_slider.value = db_to_linear(AudioServer.get_bus_index("SFX"))
	music_volume_slider.value = db_to_linear(AudioServer.get_bus_index("Music"))
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		windowed_mode_text.text = "FULLSCREEN"
	else:
		windowed_mode_text.text = "WINDOWED"
	last_focus_owner = get_viewport().gui_get_focus_owner()
	menus.append(pause_menu)
	menus.append(settings_menu)
	set_menu(pause_menu)
	get_tree().root.get_node("AudioManager").pause_sounds()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		if current_menu == pause_menu:
			queue_free()
		else:
			set_menu(pause_menu)


func _exit_tree() -> void:
	get_tree().paused = false
	if last_focus_owner:
		last_focus_owner.grab_focus()
	if Globals.upgrade_menu != null:
		Globals.upgrade_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		Globals.upgrade_menu.visible = true
	get_tree().root.get_node("AudioManager").resume_sounds()


func set_menu(new_menu: Control):
	for menu in menus:
		menu.visible = false
	current_menu = new_menu
	current_menu.visible = true
	current_menu.get_child(0).grab_focus()


func _on_continue_pressed():
	if Globals.player:
		for gun in Globals.player.guns:
			gun.process_mode = Node.PROCESS_MODE_ALWAYS
	queue_free()


func _on_quit_pressed():
	get_tree().quit()


func _on_return_to_menu_pressed():
	Globals.player = null
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
	get_tree().paused = false


func _on_settings_pressed() -> void:
	set_menu(settings_menu)


func _on_back_pressed() -> void:
	set_menu(pause_menu)


func _on_sfx_volume_scroll_down() -> void:
	sfx_volume_slider.value -= 0.1


func _on_sfx_volume_scroll_up() -> void:
	sfx_volume_slider.value += 0.1


func _on_music_volume_scroll_down() -> void:
	music_volume_slider.value -= 0.1


func _on_music_volume_scroll_up() -> void:
	music_volume_slider.value += 0.1


func _on_sfx_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))


func _on_music_vol_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))


func _on_window_mode_scroll_down() -> void:
	change_window_mode()


func _on_window_mode_scroll_up() -> void:
	change_window_mode()


func change_window_mode() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2(1280, 720))
		windowed_mode_text.text = "WINDOWED"
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		windowed_mode_text.text = "FULLSCREEN"
