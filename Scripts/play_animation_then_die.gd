extends AnimatedSprite2D

var parent


func _ready() -> void:
	parent = get_parent()


func _on_animation_finished():
	visible = false#queue_free()
	get_parent().remove_child(self)
	parent.add_child(self)
	position = Vector2.ZERO
	
