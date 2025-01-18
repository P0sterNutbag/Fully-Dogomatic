extends Node2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back") or Input.is_action_just_pressed("select"):
		get_tree().paused = false
		get_tree().root.get_node("MainMenu").visible = true
		queue_free()
