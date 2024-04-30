extends Area2D

@export var explosion: PackedScene = preload("res://Scenes/explosion.tscn")
@export var spread_modifier: float = 0
@export var shot_count: float = 1
var move_vector: Vector2
var speed: float
var damage: float = 1
var penetrations: int
var explode_chance: float = 1
var ricochet: bool = false
var homing: bool = false


func _physics_process(_delta):
	position += move_vector
	move_vector *= 0.9


func _on_timer_timeout():
	Globals.explosion_sfx.play()
	var instance = explosion.instantiate()
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position
	queue_free()

