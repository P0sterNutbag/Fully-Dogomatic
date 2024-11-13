extends Boss

var distance_to_rush = 250
var rush_speed = 80
var rush_dir = Vector2.ZERO


func attack(delta) -> void:
	super.attack(delta)
	var dis = global_position.distance_to(Globals.player.global_position)
	var dir = (Globals.player.global_position - global_position).normalized()
	velocity = lerp(velocity, dir * speed, turn_speed * delta)
	move_and_slide()
	if $RunCooldown.time_left <= 0 and dis <= distance_to_rush:
		state = states.rush
		rush_dir = (Globals.player.position - position).normalized()
		$RunTimer.start()
	$AnimatedSprite2D.speed_scale = 1


func rush(delta) -> void:
	super.rush(delta)
	rush_dir = lerp(rush_dir, (Globals.player.position - position).normalized(), 2 * delta)
	velocity = rush_dir * rush_speed
	move_and_slide()
	$AnimatedSprite2D.speed_scale = 2


func _on_run_timer_timeout():
	state = states.attack
	$RunCooldown.start()
