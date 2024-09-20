extends Sprite2D


func _ready() -> void:
	scale = Vector2.ONE * randf_range(0.5, 1.5)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.25)
	tween.tween_callback(queue_free)
