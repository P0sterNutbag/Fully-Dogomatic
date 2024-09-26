extends Node2D

@export var sprites: Array[Texture]
@export var sprite: Sprite2D
@export var speed: float = 200
@export var rotate_speed: float = 0
@export var gravity: float = 900
@export var bounces: int = 0
@export var starting_scale: float = 1
@export var scale_lerp: float = 5
var move_vector
var max_y: float = 100000


func _ready():
	bounces = randi_range(1, 2)
	move_vector = Vector2(randf_range(-0.25,0.25), randf_range(-0.75,-1)) * speed
	max_y += randf_range(-1,2)
	if sprite != null:
		sprite.texture = sprites[randi_range(0,sprites.size()-1)]
	#scale = Vector2.ONE * starting_scale


func _physics_process(delta):
	if position.y < max_y:
		position += move_vector * delta
		move_vector.y += gravity * delta
		rotate(rotate_speed)
	elif bounces > 0:
		bounces -= 1
		move_vector.y = randf_range(-0.1,-0.5) * speed
		position.y -= 1
	#if scale != Vector2.ONE:
		#scale = lerp(scale, Vector2.ONE, scale_lerp * delta)


func _on_timer_timeout():
	queue_free()
