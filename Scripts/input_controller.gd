extends Node

var input_delay := 0.15
var axis_threshold := 0.5
var mouse_hide_time := 1.5
var time_since_last_input := 0.0
var time_since_mouse_movement := 0.0


func _ready():
	Input.joy_connection_changed.connect(_on_joy_connection_changed)


func _process(delta):
	time_since_last_input += delta
	
	#show/hide mouse
	if abs(Input.get_last_mouse_velocity()) > Vector2.ZERO or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		time_since_mouse_movement = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		time_since_mouse_movement += delta
		if time_since_mouse_movement >= mouse_hide_time:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN


func get_axis_just_pressed(axis: float):
	if time_since_last_input < input_delay: 
		return 0
	time_since_last_input = 0.0
	return axis


func _on_joy_connection_changed(device: int, connected: bool):
	if !connected and get_tree().current_scene.name.contains("World"):
		PauseController.pause_game()
