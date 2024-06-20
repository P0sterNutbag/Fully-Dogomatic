extends Node2D

@export var sprites: Array[Texture]
@export var sprite: Sprite2D
@export var speed: float = 600
@export var speed_variance = 0.25
@export var rotate_speed: float = 20
@export var rotate_variance = 0.25
@export var friction: float = 20
@export var leave_trail: bool = false
@export var trail_texture: Texture2D
var move_vector


func _ready():
	rotate_speed *= randf_range(rotate_speed, 1)
	if sprite != null:
		sprite.texture = sprites[randi_range(0,sprites.size()-1)]


func set_speed(bullet_dir: float):
	speed *= randf_range(speed_variance, 1)
	move_vector = Vector2.from_angle(bullet_dir).rotated(randf_range(-0.5, 0.5)) * speed


func _physics_process(delta):
	position += move_vector * delta
	move_vector = lerp(move_vector, Vector2.ZERO, friction * delta)
	rotate(rotate_speed)
	rotate_speed = lerp(rotate_speed, float(0), friction * delta)


func _on_timer_timeout():
	queue_free()


func _on_trail_timeout():
	if abs(move_vector) > Vector2(1, 1):
		var trail = Sprite2D.new()
		get_tree().current_scene.add_child(trail)
		trail.position = global_position
		trail.texture = trail_texture
		trail.use_parent_material = true
		trail.z_index = -100
		trail.rotation_degrees = randf_range(-90, 90)
		
		$Trail.wait_time *= 2
