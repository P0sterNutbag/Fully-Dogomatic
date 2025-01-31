extends Area2D
class_name Bullet

@export var destroy_on_hit: bool = true
@export var friction: float = 0
@export var can_damage_player: bool
var damage: float = 1
var damage_boost: float = 0
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
var can_damage: bool = true
var can_delete: bool = true
@export var explosion = preload("res://Scenes/Bullets/bullet_explosion.tscn")
var damage_number = preload("res://Scenes/Particles/damage_number.tscn")
var impact = preload("res://Scenes/Particles/impact.tscn")
var spark = preload("res://Scenes/Particles/bullet_spark.tscn")


func _enter_tree() -> void:
	can_damage = true
	can_delete = true
	if homing:
		$HomingArea.process_mode = Node.PROCESS_MODE_INHERIT
	if randi_range(0,1) == 1:
		scale.y *= -1


func _physics_process(delta):
	position += move_vector * delta
	if homing: 
		if target_enemy != null:
			var target_vector = (target_enemy.position - position).normalized() * speed
			move_vector = lerp(move_vector, target_vector, 7.5 * delta)
			if global_position.distance_to(target_enemy.global_position) < 1:
				target_enemy = null
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
			get_parent().call_deferred("remove_child", self)
	elif global_position.x > bottom_right_bound.x:
		if can_warp:
			global_position.x = top_left_bound.x
			can_warp = false
		else:
			get_parent().call_deferred("remove_child", self)
	elif global_position.y < top_left_bound.y:
		if can_warp:
			global_position.y = bottom_right_bound.y
			can_warp = false
		else:
			get_parent().call_deferred("remove_child", self)
	elif global_position.y > bottom_right_bound.y:
		if can_warp:
			global_position.y = top_left_bound.y
			can_warp = false
		else:
			get_parent().call_deferred("remove_child", self)
	#if global_position.distance_to(Globals.player.global_position) > 260:
		#queue_free()


func _on_area_entered(area):
	if (area.is_in_group("enemy") or can_damage_player) and can_damage:
		if can_damage_player and area.get_parent() is Player:
			area.get_parent().take_damage(damage)
		else:
			area.take_damage(damage, rotation)
		#var inst = impact.instantiate()
		#get_tree().current_scene.add_child(inst)
		#inst.global_position = area.global_position
		#inst.rotation = rotation
		if get_tree().get_nodes_in_group("particles").size() < 100:
			var instance = damage_number.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = area.global_position + Vector2.UP * 8
			instance.get_node("Text").text += str(damage)
		#for i in randi_range(3, 4):
			#var spark_inst = spark.instantiate()
			#get_tree().current_scene.add_child(spark_inst)
			#spark_inst.global_position = area.global_position
			#spark_inst.set_speed(-rotation_degrees)
		if ricochet:
			if abs(move_vector.x) > abs(move_vector.y):
				move_vector.x *= -1
			else:
				move_vector.y *= -1
			rotation = move_vector.angle()
		if randf_range(0, 1) < explode_chance:
			call_deferred("create_explosion", area.global_position)
		penetrations -= 1
		if penetrations <= 0 and destroy_on_hit:
			queue_free()
		elif homing:
			target_enemy = null


func create_explosion(spawn_position: Vector2):
	var inst = explosion.instantiate()
	inst.global_position = spawn_position
	inst.damage += damage_boost
	get_tree().current_scene.add_child(inst)
	#Globals.create_instance(explosion, spawn_position)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if target_enemy == null:
		target_enemy = area.get_parent()
