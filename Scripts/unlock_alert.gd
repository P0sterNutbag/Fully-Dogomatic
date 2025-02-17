extends Control


func set_character(index: int):
	if index == 5:
		$RichTextLabel.hide()
		$RichTextLabel2.show()
		return
	$Characters.get_child(index).show()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("select") or Input.is_action_just_pressed("back"):
		queue_free()
