extends Area2D

var target_position
var follow_player = false
var fade = false


func _ready():
	target_position = Vector2(randf_range(-5,5),randf_range(-5,5))
	rotation = randf_range(0, 360)


func _physics_process(_delta):
	if follow_player:
		target_position = Globals.player.global_position
		global_position += (target_position - global_position).normalized() * 3
		#if global_position.distance_to(Globals.player.global_position) < 1:
			#Globals.player.get_money(1)
			#queue_free()
	#else:
		#global_position = lerp(global_position, target_position, 0.1)

func _process(delta):
	if fade:
		modulate.a -= delta
		if modulate.a <= 0:
			queue_free()

func _on_timer_timeout():
	fade = true


func _on_area_entered(area: Area2D) -> void:
	Globals.player.get_money(1)
	queue_free()
