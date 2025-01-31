extends Bullet

func _process(delta: float) -> void:
	rotate(deg_to_rad(300) * delta)
