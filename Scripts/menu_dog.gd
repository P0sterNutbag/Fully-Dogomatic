extends AnimatedSprite2D

var velocity: Vector2
var target_position: Vector2
var walk_speed = 25
var run_speed = 45
var move_anim = "walk"
var fetch_ball: Node2D
var in_mouse: bool

func _process(delta):
	# move towards the menu item
	if target_position != Vector2.ZERO:
		if global_position.distance_to(target_position) > 1:
			velocity = (target_position - global_position).normalized() * run_speed
			move_anim = "run"
		else:
			velocity = Vector2.ZERO
			target_position = Vector2.ZERO
			fetch_ball = null
	
	if fetch_ball != null:
		target_position = fetch_ball.position
	# actually move
	position += velocity * delta
	position.x = clamp(position.x, 0, 320)
	position.y = clamp(position.y, 0, 180)
	# pet
	if in_mouse and !get_parent().get_node("Tennisball").follow_mouse:
		if Input.get_last_mouse_velocity() > Vector2.ONE:
			$Heart.visible = true
			$HeartTimer.start()
	# animate
	if velocity.x < 0:
		scale = Vector2(-1, 1)
		play(move_anim)
	elif velocity.x > 0:
		scale = Vector2.ONE
		play(move_anim)
	else:
		play("idle")
		


func _on_move_timer_timeout():
	$MoveTimer.wait_time = randf_range(1, 3);
	if velocity == Vector2.ZERO:
		velocity = Vector2(randf_range(-walk_speed, walk_speed), randf_range(-walk_speed, walk_speed))
		move_anim = "walk"
	else:
		velocity = Vector2.ZERO


func _on_area_2d_mouse_entered():
	in_mouse = true


func _on_area_2d_mouse_exited():
	in_mouse = false


func _on_heart_timer_timeout():
	$Heart.visible = false
