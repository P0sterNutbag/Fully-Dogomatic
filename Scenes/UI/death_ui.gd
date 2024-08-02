extends Menu


func _ready():
	super._ready()
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25)


#func _on_color_rect_gui_input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")
		#var tween = create_tween()
		#tween.tween_property($Restart, "scale", Vector2.ZERO, 0.25)
#
#
#func _on_quit_rect_gui_input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		#SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
		#var tween = create_tween()
		#tween.tween_property($Quit, "scale", Vector2.ZERO, 0.25)


func _on_restart_on_press():
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")


func _on_quit_on_press():
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
