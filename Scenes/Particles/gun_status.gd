extends Control


func _ready():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "global_position", global_position + Vector2(0, -2), 0.4)
	tween.tween_callback(queue_free)

