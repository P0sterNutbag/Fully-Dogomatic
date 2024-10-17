extends Enemy


func _on_hitbox_area_entered(area: Area2D) -> void:
	var player = area.get_parent()
	if player.state != Globals.player.states.bounce:
		return
	player.state = Globals.player.states.bounce
	player.velocity = (player.global_position - global_position).normalized() * 1000
	player.take_damage(damage)
