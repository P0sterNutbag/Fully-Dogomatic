extends CharacterBody2D

var target
var speed = 100
var turn_speed = 1
var death_explosion = preload("res://Scenes/Enemies/enemy_explosion.tscn")

func _ready() -> void:
	if Globals.player != null:
		target = Globals.player
	velocity = (Vector2.RIGHT * speed).rotated(deg_to_rad(randf_range(0, 360)))


func _physics_process(delta: float) -> void:
	if target == null:
		return
	
	var dir = (target.global_position - global_position).normalized()
	velocity = lerp(velocity, dir * speed, turn_speed * delta)
	move_and_slide()
	
	rotation = velocity.angle()
	
	if global_position.distance_to(target.global_position) < 8:
		queue_free()


func take_damage(dmg: float, bullet_direction: float):
	queue_free()


func _exit_tree() -> void:
	Globals.create_instance(death_explosion, global_position)
