extends Area2D

var explosion: PackedScene = preload("res://Scenes/Bullets/grenade_explosion.tscn")
@export var spread_modifier: float = 0
@export var shot_count: float = 1
var damage_boost: float = 1
var move_vector: Vector2
var deceleration: float = 0.7
var speed: float
var damage: float = 1
var penetrations: int
var explode_chance: float = 1
var ricochet: bool = false
var homing: bool = false
var target_enemy: Node2D
var can_warp: bool
var range: float
var knockback_force: float


func _ready() -> void:
	deceleration *= randf_range(0.9, 1.1)
	deceleration = clamp(deceleration, 0, 0.9)
	if range > 0:
		deceleration *= 2


func _physics_process(delta):
	position += move_vector * delta
	rotation = move_vector.angle()
	move_vector *= deceleration
	if homing: 
		if target_enemy != null:
			var target_vector = move_vector.rotated(global_position.angle_to(target_enemy.position - position))
			move_vector = lerp(move_vector, target_vector, 7.5 * delta)
		rotation = move_vector.angle()


func _process(delta: float) -> void:
	var top_left_bound = Vector2(Globals.camera.get_screen_center_position().x - 240, Globals.camera.get_screen_center_position().y - 180)
	var bottom_right_bound = Vector2(Globals.camera.get_screen_center_position().x + 240, Globals.camera.get_screen_center_position().y + 180)
	if global_position.x < top_left_bound.x:
		if can_warp:
			global_position.x = bottom_right_bound.x
			can_warp = false
		else:
			queue_free()
	elif global_position.x > bottom_right_bound.x:
		if can_warp:
			global_position.x = top_left_bound.x
			can_warp = false
		else:
			queue_free()
	elif global_position.y < top_left_bound.y:
		if can_warp:
			global_position.y = bottom_right_bound.y
			can_warp = false
		else:
			queue_free()
	elif global_position.y > bottom_right_bound.y:
		if can_warp:
			global_position.y = top_left_bound.y
			can_warp = false
		else:
			queue_free()


func _on_timer_timeout():
	Globals.audio_manager.explosion.play()
	var instance = explosion.instantiate()
	get_tree().current_scene.add_child(instance)
	instance.global_position = global_position
	instance.damage *= damage_boost
	instance.knockback_force = knockback_force
	queue_free()


func _on_homing_area_area_entered(area: Area2D) -> void:
	if target_enemy == null:
		target_enemy = area.get_parent()
