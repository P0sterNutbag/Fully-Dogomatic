extends Bullet


func _on_area_entered(area: Area2D) -> void:
	if abs(move_vector) <= Vector2.ONE:
		queue_free()


func _on_attract_area_area_entered(area: Area2D) -> void:
	area.get_parent().target = self


func _on_timer_timeout() -> void:
	queue_free()
