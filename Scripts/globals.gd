extends Node

var player
var crate_spawner
var shoot_sfx
var reload_sfx
var explosion_sfx
var world_controller
var ui_guns
var gunstats


func create_instance(scene: PackedScene, position: Vector2):
	if (scene != null):
		var instance = scene.instantiate()
		get_tree().get_root().add_child(instance)
		instance.global_position = position


func generate_circle_points(center: Vector2, radius: float, segments: int) -> Array:
	var points = []
	var angle_increment = 2 * PI / segments
	for i in range(segments):
		var angle = i * angle_increment
		var x = center.x + radius * cos(angle)
		var y = center.y + radius * sin(angle)
		points.append(Vector2(x, y))
	points.append(points[0])
	return points


func get_random_index(array: Array) -> int:
	var sum = 0
	for i in array.size():
		sum += array[i].spawn_chance
	var rand_num = randi_range(0, sum)
	var current_num = 0
	for i in array.size():
		current_num += array[i].spawn_chance
		if rand_num <= current_num:
			return i
	return -1


func activate_gunstats():
	gunstats.visible = true


func deactivate_gunstats():
	gunstats.visible = false
