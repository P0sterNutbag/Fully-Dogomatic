extends Control

var last_focus_owner: Control


func _ready():
	last_focus_owner = get_viewport().gui_get_focus_owner()
	$Menu/VBoxContainer/Continue.grab_focus()
	get_tree().root.get_node("AudioManager").pause_sounds()


func _on_continue_pressed():
	get_tree().paused = false
	get_tree().root.get_node("AudioManager").resume_sounds()
	if last_focus_owner:
		last_focus_owner.grab_focus()
	if Globals.player:
		for gun in Globals.player.guns:
			gun.process_mode = Node.PROCESS_MODE_ALWAYS
	queue_free()


func _on_quit_pressed():
	get_tree().quit()


func _on_mute_pressed():
	Globals.audio_manager.mute()


func _on_fullscreen_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)


func _on_return_to_menu_pressed():
	Globals.player = null
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
	get_tree().paused = false


func _exit_tree():
	if Globals.upgrade_menu != null:
		Globals.upgrade_menu.process_mode = Node.PROCESS_MODE_ALWAYS
		Globals.upgrade_menu.visible = true



func _on_color_rect_gui_input(event):
	pass 


func _on_color_rect_mouse_entered():
	pass


func _on_color_rect_mouse_exited():
	pass



#func _on_mute_toggled(toggled_on):
	#if toggled_on:
		#$Menu/VBoxContainer/Mute.text = "UNMUTE"
	#else:
		#$Menu/VBoxContainer/Mute.text = "MUTE"
#
#
#func _on_fullscreen_toggled(toggled_on):
	#if toggled_on:
		#$Menu/VBoxContainer/Fullscreen.text = "WINDOWED"
	#else:
		#$Menu/VBoxContainer/Fullscreen.text = "FULLSCREEN"
