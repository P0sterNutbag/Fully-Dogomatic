extends Control


func _ready():
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25)


func _on_restart_pressed():
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")


func _on_quit_pressed():
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
