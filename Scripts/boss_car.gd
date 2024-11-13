extends Boss

var dir = Vector2.RIGHT


func attack(delta) -> void:
	super.attack(delta)
	dir = (Globals.player.global_position - global_position).normalized()
	global_position.y = Globals.player.global_position.y + 16


func rush(delta) -> void:
	super.rush(delta)
	velocity = dir * speed
	global_position.y = move_toward(global_position.y, Globals.player.global_position.y + 16, 30 * delta)
	move_and_slide()
	if global_position.x > Globals.world_controller.barrier_right.global_position.x + 60 or global_position.x < -60:
		state = states.attack
		$Cooldown.start()


func _on_cooldown_timeout() -> void:
	state = states.rush
