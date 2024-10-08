extends Node

var pause_menu = preload("res://Scenes/UI/settings_menu.tscn")
var pause_menu_instance
var music_volume: int = 10
var sfx_volume: int = 10
var upgrade_menu


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Globals.pause_controller = self


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_game()


func pause_game():
	var ui = get_tree().current_scene.get_node_or_null("UI")
	if pause_menu_instance == null and ui != null:
		if !get_tree().paused:
			get_tree().paused = true
			pause_menu_instance = pause_menu.instantiate()
			pause_menu_instance.global_position = Vector2(0, 0)
			ui.add_child(pause_menu_instance)
			if ui.scale == Vector2.ONE * 2:
				pause_menu_instance.scale = Vector2.ONE * 0.5
	#else:
		#get_tree().paused = false
		#if pause_menu_instance != null:
			#pause_menu_instance.queue_free()


func _on_options_gui_input(event):
	if event is InputEventMouseButton:
		pause_game()
