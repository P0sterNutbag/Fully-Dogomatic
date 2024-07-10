extends RichTextLabel

var target_scale = Vector2.ONE


func _process(delta):
	scale = lerp(scale, target_scale, 10 * delta)


func _on_mouse_entered():
	target_scale = Vector2.ONE * 1.25


func _on_mouse_exited():
	target_scale = Vector2.ONE
