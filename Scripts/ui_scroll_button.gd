extends UiButton
class_name UiScrollButton

signal scroll_up
signal scroll_down


func _process(delta: float) -> void:
	if has_focus():
		if Input.is_action_just_pressed("ui_left"):
			scroll_down.emit()
		if Input.is_action_just_pressed("ui_right"):
			scroll_up.emit()
