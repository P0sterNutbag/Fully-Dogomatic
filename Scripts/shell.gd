extends Sprite2D

@export var sprites: Array[Texture]
var move_vector
var gravity = 900
var max_y: float
var speed = 200
var rotate_speed: float
var bounces: int


# Called when the node enters the scene tree for the first time.
func _ready():
	bounces = randi_range(1, 2)
	move_vector = Vector2(randf_range(-0.25,0.25), randf_range(-0.75,-1)) * speed
	max_y += randf_range(-1,2)
	rotate_speed = randf_range(-1, 1) 
	texture = sprites[randi_range(0,sprites.size()-1)]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if position.y < max_y:
		position += move_vector * delta
		move_vector.y += gravity * delta
		rotate(rotate_speed)
	elif bounces > 0:
		bounces -= 1
		move_vector.y = randf_range(-0.1,-0.5) * speed
		position.y -= 1


func _on_timer_timeout():
	queue_free()
