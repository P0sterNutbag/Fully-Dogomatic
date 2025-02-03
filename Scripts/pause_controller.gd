extends Node

var pause_menu_instance
@onready var pause_menu = $PauseMenu


func _ready():
	Globals.pause_controller = self


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().current_scene.name.contains("World") and !pause_menu.visible and (!Globals.upgrade_menu or Globals.upgrade_menu.can_pause):
			pause_game()


func pause_game():
	pause_menu.already_paused = get_tree().paused
	get_tree().paused = true
	pause_menu.activate()
	#if Globals.ui.scale == Vector2.ONE * 2:
		#pause_menu_instance.scale = Vector2.ONE * 0.5
	#else:
		#get_tree().paused = false
		#if pause_menu_instance != null:
			#pause_menu_instance.queue_free()


func _on_options_gui_input(event):
	if event is InputEventMouseButton:
		pause_game()
