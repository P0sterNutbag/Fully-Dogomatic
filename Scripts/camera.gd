extends Camera2D

#var aim_offset: float = 25


func _ready():
	Globals.camera = self


#func _process(delta):
	#var move_vector = get_global_mouse_position()-Globals.player.global_position.normalized() * aim_offset
	#move_vector = clamp(move_vector, -Vector2.ONE * aim_offset, Vector2.ONE * aim_offset)
	#position = Globals.player.global_position + move_vector


func screenshake(intensity: float):
	intensity = clamp(intensity, 1, 3)
	offset += Vector2.ONE * randi_range(-intensity, intensity)
	await get_tree().create_timer(0.05).timeout
	offset = Vector2.ZERO
