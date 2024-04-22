extends Control

signal pushed

var target_scale: Vector2 = Vector2.ONE
var highlight_scale = Vector2.ONE * 1.25


func _process(delta):
	if scale != target_scale:
		scale = lerp(scale, target_scale, delta * 5)
		

func _on_mouse_entered():
	target_scale = highlight_scale


func _on_mouse_exited():
	target_scale = Vector2.ONE


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pushed.emit()
