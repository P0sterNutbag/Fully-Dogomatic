extends Boss

var jump_speed = 150
@onready var jump_cooldown = $JumpCooldown


func rush(delta) -> void:
	super.rush(delta)
	var dir = ((Globals.player.global_position + Vector2.DOWN * aim_y_offset) - global_position).normalized()
	velocity = lerp(velocity, dir * jump_speed, turn_speed * delta)
	move_and_slide()


func _on_jump_cooldown_timeout() -> void:
	state = states.rush
	$AnimatedSprite2D.velocity = Vector2.UP * 5
	$Hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	$Hurtbox.process_mode = Node.PROCESS_MODE_DISABLED


func _on_animated_sprite_2d_reached_ground() -> void:
	state = states.attack
	$Hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	$Hurtbox.process_mode = Node.PROCESS_MODE_INHERIT
	jump_cooldown.start()
