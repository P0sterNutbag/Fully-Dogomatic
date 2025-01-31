extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() == Globals.player:
		Globals.player.speed = Globals.player.speed * 0.65
		get_parent().get_node("Sprite2D").modulate = Color.RED

func _on_area_exited(area: Area2D) -> void:
	if area.get_parent() == Globals.player:
		Globals.player.speed = Globals.player.base_speed
		get_parent().get_node("Sprite2D").modulate = Color.WHITE
