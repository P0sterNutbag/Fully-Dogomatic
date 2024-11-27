extends Area2D
class_name Bullet

@export var destroy_on_hit: bool = true
@export var friction: float = 0
var damage: float = 1
var spread_modifier: float = 0
var shot_count: float = 1
var penetrations: int = 1
var move_vector: Vector2
var speed: float
var ricochet: bool = false
var explode_chance: float = 0
var homing: bool = false
var target_enemy
var can_warp: bool
var hit_enemies: Array
var can_damage: bool = true
@export var explosion = preload("res://Scenes/Bullets/bullet_explosion.tscn")
var damage_number = preload("res://Scenes/Particles/damage_number.tscn")
var impact = preload("res://Scenes/Particles/impact.tscn")
var spark = preload("res://Scenes/Particles/bullet_spark.tscn")

func _ready():
	await get_tree().create_timer(0.01).timeout
	if homing:
		$HomingArea.process_mode = Node.PROCESS_MODE_INHERIT
		#target_enemy = get_nearest_enemy()
	if randi_range(0,1) == 1:
		scale.y *= -1


func _physics_process(delta):
	position += move_vector * delta
	if homing: 
		if target_enemy != null:
			var target_vector = (target_enemy.position - position).normalized() * speed
			move_vector = lerp(move_vector, target_vector, 7.5 * delta)
		#else:
			#target_enemy = get_nearest_enemy()
		rotation = move_vector.angle()
	if friction > 0:
		move_vector = lerp(move_vector, Vector2.ZERO, friction * delta)
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
	#if global_position.distance_to(Globals.player.global_position) > 260:
		#queue_free()


func _on_area_entered(area):
	if area.is_in_group("enemy") and can_damage:
		#OS.delay_msec(10 / shot_count)
		area.take_damage(damage, rotation)
		var inst = impact.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.global_position = area.global_position
		inst.rotation = rotation
		var instance = damage_number.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = area.global_position + Vector2.UP * 8
		instance.get_node("Text").text += str(damage)
		for i in randi_range(3, 4):
			var spark_inst = spark.instantiate()
			get_tree().current_scene.add_child(spark_inst)
			spark_inst.global_position = area.global_position
			spark_inst.set_speed(-rotation_degrees)
		if ricochet:
			if abs(move_vector.x) > abs(move_vector.y):
				move_vector.x *= -1
			else:
				move_vector.y *= -1
			#var vector_to_enemy = area.global_position - global_position
			#if vector_to_enemy.x > vector_to_enemy.y:
				#move_vector.y *= -1
			#else:
				#move_vector.x *= -1
			rotation = move_vector.angle()
		if randf_range(0, 1) < explode_chance:
			call_deferred("create_explosion", area.global_position)
		penetrations -= 1
		if penetrations <= 0 and destroy_on_hit:
			can_damage = false
			queue_free()
		elif homing:
			hit_enemies.append(target_enemy)
			#target_enemy = get_nearest_enemy()


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


func _on_area_2d_area_entered(area: Area2D) -> void:
	if target_enemy == null:
		target_enemy = area.get_parent()


func _on_homing_area_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
