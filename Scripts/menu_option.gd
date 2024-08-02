extends RichTextLabel
class_name MenuOption

@export var function_name: String
signal on_press


func grow():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2.ONE * 1.25, 0.25)


func shrink():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25)


func _on_mouse_entered():
	grow()


func _on_mouse_exited():
	shrink()


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		on_press.emit()
