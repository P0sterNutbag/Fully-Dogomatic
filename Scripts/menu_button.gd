extends RichTextLabel

@export var function_name: String
var target_scale = Vector2.ONE
signal on_press

func _process(delta):
	scale = lerp(scale, target_scale, 10 * delta)


func _on_mouse_entered():
	get_owner().set_new_index(get_owner().options.find(self))
	#target_scale = Vector2.ONE * 1.25


func _on_mouse_exited():
	get_owner().set_new_index(-1)
	#target_scale = Vector2.ONE


func _on_gui_input(event):
	if event is InputEventMouseButton:
		on_press.emit()
