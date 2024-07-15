extends Sprite2D

var speed = 60
var in_mouse: bool
var follow_mouse: bool
var last_position: Vector2
var velocity: Vector2
var left_barrier: Vector2
var right_barrier: Vector2

func _ready():
	var size = texture.get_size()
	left_barrier = Vector2(80.0 + (size.x / 2.0), 0 + (size.y / 2.0))
	right_barrier = Vector2(560 - (size.x / 2), 360 - (size.y / 2.0))
	last_position = position


func _process(delta):
	# move
	if in_mouse and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		follow_mouse = true
		velocity = Vector2.ZERO
	if follow_mouse:
		position = get_global_mouse_position()
		if Input.is_action_just_released("select"):
			follow_mouse = false
			var dog = get_parent().get_node("MenuDog")
			dog.fetch_ball = self
		velocity = (position - last_position) * speed
		last_position = position
	else:
		position += velocity * delta
		velocity = lerp(velocity, Vector2.ZERO, 2.5 * delta)
		if position.x < left_barrier.x or position.x > right_barrier.x:
			velocity.x *= -1
		if position.y < left_barrier.y or position.y > right_barrier.y:
			velocity.y *= -1
	position.x = clamp(position.x, left_barrier.x, right_barrier.x)
	position.y = clamp(position.y, left_barrier.y, right_barrier.y)
	# animate
	if !follow_mouse:
		rotation_degrees += abs(velocity.x + velocity.y) * 0.1


func _on_area_2d_mouse_entered():
	in_mouse = true


func _on_area_2d_mouse_exited():
	in_mouse = false
