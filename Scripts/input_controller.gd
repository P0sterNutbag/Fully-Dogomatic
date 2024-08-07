extends Node

var input_delay := 0.15
var axis_threshold := 0.5
var mouse_hide_time := 1.5
var time_since_last_input := 0.0
var time_since_mouse_movement := 0.0



func _process(delta):
	time_since_last_input += delta
	
	#show/hide mouse
	if abs(Input.get_last_mouse_velocity()) <= Vector2.ZERO:
		time_since_mouse_movement += delta
		if time_since_mouse_movement >= mouse_hide_time:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		time_since_mouse_movement = 0
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func get_axis_just_pressed(axis: float):
	if time_since_last_input < input_delay: 
		return 0
	time_since_last_input = 0.0
	return axis
