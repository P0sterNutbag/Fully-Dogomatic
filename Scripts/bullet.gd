extends Area2D

@export var damage: float = 1
@export var spread_modifier: float = 0
@export var shot_count: float = 1
@export var penetrations: int = 1
@export var explosion: PackedScene

var move_vector: Vector2
var speed: float
var ricochet: bool = false
var explode_chance: float = 0
var homing: bool = false
var target_enemy
var hit_enemies: Array


func _ready():
	await get_tree().create_timer(0.01).timeout
	if homing:
		target_enemy = get_nearest_enemy()


func _physics_process(delta):
	position += move_vector * 80 * delta
	if homing and target_enemy != null:
		var target_vector = (target_enemy.position - position).normalized() * speed
		move_vector = lerp(move_vector, target_vector, 7.5 * delta)
		rotation = move_vector.angle()
	if global_position.distance_to(Globals.player.global_position) > 340:
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(damage)
		penetrations -= 1
		if ricochet:
			move_vector.y *= -1
			rotation = move_vector.angle()
		if randf_range(0, 1) < explode_chance:
			call_deferred("create_explosion", area.global_position)
		if penetrations <= 0:
			queue_free()
		elif homing:
			hit_enemies.append(target_enemy)
			target_enemy = get_nearest_enemy()


func create_explosion(spawn_position: Vector2):
	Globals.create_instance(explosion, spawn_position)


func get_nearest_enemy():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest_dist = 100000
	var closest_enemy
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_dist and not hit_enemies.has(enemy):
			closest_enemy = enemy
			closest_dist = distance
	return closest_enemy
