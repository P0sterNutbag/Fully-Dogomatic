extends Control

@export var options: Array[Resource]
var option_objects: Array[Control]
var option_index = 0
var gap = 30
var yoffset = 24
var xoffset = 104
var selected_offset = 10
var settings_option = preload("res://Scenes/UI/settings_option.tscn")


func _ready():
	get_tree().paused = true
	options[1].toggle_value = Globals.muted
	options[2].toggle_value = DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	for option in options:
		var inst = settings_option.instantiate()
		inst.text = option.name.to_upper()
		if option.is_toggle:
			if option.toggle_value:
				inst.get_node("Toggle").text = "ON"
			else:
				inst.get_node("Toggle").text = "OFF"
		else:
			inst.get_node("Toggle").text = ""
		option_objects.append(inst)
		inst.get_node("ColorRect").connect("mouse_entered", _on_option_mouse_entered.bind(inst))
		inst.get_node("ColorRect").connect("mouse_exited", _on_option_mouse_entered.bind(null))
		add_child(inst)
		inst.global_position = global_position + Vector2(xoffset, yoffset)
		yoffset += gap
	change_index(0)


func _process(_delta):
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		change_index(int(Input.get_axis("up", "down")))
	if Input.is_action_just_pressed("select"):
		call_option_method()


func change_index(change_int: int):
	var new_index = option_index + change_int
	if new_index < 0:
		new_index = options.size() - 1
	elif new_index > options.size() - 1:
		new_index = 0
	option_index = new_index
	for i in option_objects.size():
		var option = option_objects[i]
		option.target_scale = Vector2.ONE
		if option.get_index()-1 == option_index:
			option.target_scale = Vector2.ONE * 1.25


func _on_option_mouse_entered(selected_option: Control):
	print_debug("mouse entered")
	for i in option_objects.size():
		var option = option_objects[i]
		option.target_scale = Vector2.ONE
		if option == selected_option:
			option.target_scale = Vector2.ONE * 1.25
			option_index = option.get_index()-1


func call_option_method():
	if options[option_index].is_toggle:
		if option_objects[option_index].get_node("Toggle").text == "OFF":
			option_objects[option_index].get_node("Toggle").text = "ON"
		else:
			option_objects[option_index].get_node("Toggle").text = "OFF"
	var callable = Callable(self, options[option_index].method)
	callable.call()


func continue_game():
	get_tree().paused = false
	queue_free()


func mute():
	Globals.audio_manager.mute()


func to_menu():
	if get_tree().current_scene.name == "World":
		Globals.world_controller.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
	if get_tree().current_scene.name == "MainMenu":
		get_tree().current_scene.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
	get_tree().paused = false
	#get_tree().change_scene_to_file("res://Scenes/Levels/main_menu.tscn")


func quit_game():
	get_tree().quit()


func toggle_fullscreen():
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

