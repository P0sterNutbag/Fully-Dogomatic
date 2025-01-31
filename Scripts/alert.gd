extends Control


func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", global_position + Vector2.UP * 12, 1)
	tween.tween_callback(queue_free)
