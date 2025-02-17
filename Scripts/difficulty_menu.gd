extends Control


func move_in() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2.ZERO, 0.5)
	$NormalMode.grab_focus()


func _on_hard_mode_pressed() -> void:
	Globals.hard_mode = true
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")


func _on_normal_mode_pressed() -> void:
	Globals.hard_mode = false
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")
