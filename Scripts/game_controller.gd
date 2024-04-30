extends Node2D

var pause_menu = preload("res://Scenes/UI/settings_menu.tscn")
var pause_menu_instance

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_game()


func pause_game():
	if not get_tree().paused:
		get_tree().paused = true
		pause_menu_instance = pause_menu.instantiate()
		pause_menu_instance.global_position = Vector2(0, 0)
		get_tree().current_scene.get_node("CanvasLayer").add_child(pause_menu_instance)
	else:
		get_tree().paused = false
		if pause_menu_instance != null:
			pause_menu_instance.queue_free()
