extends AnimatedSprite2D

var velocity: Vector2
var target_position: Vector2
var walk_speed = 45
var run_speed = 100
var move_anim = "run"
var fetch_ball: Node2D
var in_mouse: bool
var left_barrier: Vector2
var right_barrier: Vector2


func _ready():
	var size = get_sprite_frames().get_frame_texture("idle",0).get_size()
	left_barrier = Vector2(0 + (size.x), 0 + (size.y))
	right_barrier = Vector2(480 - (size.x), 360 - (size.y))
	$MoveTimer.wait_time = randf_range(0.1, 2)
	$MoveTimer.start()


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
	position.x = clamp(position.x, left_barrier.x, right_barrier.x)
	position.y = clamp(position.y, left_barrier.y, right_barrier.y)
	# pet
	if global_position.distance_to(get_global_mouse_position()) < 20:# and !get_parent().get_node("Tennisball").follow_mouse:
		if Input.get_last_mouse_velocity() > Vector2.ONE:
			$Heart.visible = true
			$HeartTimer.start()
	# animate
	if velocity.x < 0:
		scale = Vector2(-1, 1)*2
		play(move_anim)
	elif velocity.x > 0:
		scale = Vector2.ONE*2
		play(move_anim)
	else:
		play("idle")
		


func _on_move_timer_timeout():
	$MoveTimer.wait_time = randf_range(1, 3)
	if velocity == Vector2.ZERO:
		velocity = Vector2(randf_range(-walk_speed, walk_speed), randf_range(-walk_speed, walk_speed))
		move_anim = "run"
	else:
		velocity = Vector2.ZERO


func _on_area_2d_mouse_entered():
	in_mouse = true


func _on_area_2d_mouse_exited():
	in_mouse = false


func _on_heart_timer_timeout():
	$Heart.visible = false
