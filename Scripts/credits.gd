extends Node2D


#func _ready() -> void:
	#$CanvasLayer/Credits.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back"):# or Input.is_action_just_pressed("select"):
		return_to_menu()


func return_to_menu() -> void:
	get_tree().paused = false
	get_tree().root.get_node("MainMenu").visible = true
	queue_free()


func _on_credits_pressed() -> void:
	return_to_menu()
