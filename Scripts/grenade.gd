extends Area2D

@export var explosion: PackedScene = preload("res://Scenes/Particles/explosion.tscn")
@export var spread_modifier: float = 0
@export var shot_count: float = 1
var move_vector: Vector2
var deceleration: float = 0.8
var speed: float
var damage: float = 1
var penetrations: int
var explode_chance: float = 1
var ricochet: bool = false
var homing: bool = false
var target_enemy: Node2D


func _ready() -> void:
	deceleration *= randf_range(0.9, 1.1)
	deceleration = clamp(deceleration, 0, 0.9)


func _physics_process(delta):
	position += move_vector 
	rotation = move_vector.angle()
	move_vector *= deceleration
	if homing: 
		if target_enemy != null:
			var target_vector = move_vector.rotated(global_position.angle_to(target_enemy.position - position))
			move_vector = lerp(move_vector, target_vector, 7.5 * delta)
		rotation = move_vector.angle()


func _on_timer_timeout():
	Globals.audio_manager.explosion.play()
	var instance = explosion.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position
	queue_free()


func _on_homing_area_area_entered(area: Area2D) -> void:
	if target_enemy == null:
		target_enemy = area.get_parent()
