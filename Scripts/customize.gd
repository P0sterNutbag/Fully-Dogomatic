extends Node2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):
		SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
