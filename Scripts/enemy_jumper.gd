extends Enemy

var sprite_velocity = Vector2.ZERO


func _process(delta: float) -> void:
	super._process(delta)
	if sprite.position.y >= 0:
		sprite_velocity = Vector2.UP * 300
	sprite.position += sprite_velocity * delta
	sprite_velocity.y += gravity * delta
	if sprite.position.y > -20:
		$Hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		$Hurtbox.process_mode = Node.PROCESS_MODE_INHERIT
		set_collision_mask_value(4, true)
	else:
		$Hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		$Hurtbox.process_mode = Node.PROCESS_MODE_DISABLED
		set_collision_mask_value(4, false)
