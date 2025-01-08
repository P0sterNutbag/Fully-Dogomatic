extends AnimatedSprite2D


func _enter_tree() -> void:
	play("default")


func _on_animation_finished():
	get_parent().call_deferred("remove_child", self)
