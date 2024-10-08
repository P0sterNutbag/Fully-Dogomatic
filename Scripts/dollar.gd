extends Area2D

var target_position
var follow_player = false
var fade = false
var direction = 0
var speed = 1000
var fric = 1
var starting_dis = 0


func _ready():
	if direction == 0:
		target_position = global_position + Vector2(randf_range(-32,16),randf_range(-32,16))
	else:
		target_position = global_position + Vector2.RIGHT.rotated(direction) * randf_range(8, 16)
	starting_dis = global_position.distance_to(target_position)
	rotation = randf_range(0, 360)


func _process(delta) -> void:
	if follow_player:
		target_position = Globals.player.global_position
		global_position += (target_position - global_position).normalized() * 250 * delta
		rotate(10 * delta)
		#if global_position.distance_to(Globals.player.global_position) < 1:
			#Globals.player.get_money(1)
			#queue_free()
	else:
		global_position = lerp(global_position, target_position, 25 * delta)
		if global_position.distance_to(target_position) > 1:
			rotate(global_position.distance_to(target_position) * delta)
	
	if fade:
		modulate.a -= delta
		if modulate.a <= 0:
			queue_free()


func _on_timer_timeout():
	fade = true


func _on_area_entered(area: Area2D) -> void:
	Globals.player.get_money(1)
	queue_free()
