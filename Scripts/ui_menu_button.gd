extends Button


func _process(delta):
	if is_hovered():
		grab_focus()
