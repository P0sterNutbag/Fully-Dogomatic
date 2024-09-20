extends Node2D

var dust = preload("res://Scenes/Particles/dust.tscn")
var dust_amount = 3



func _on_timer_timeout() -> void:
	if !abs(owner.velocity) > Vector2.ZERO:
		return
	if get_parent().frame != 3:
		return
	for i in dust_amount:
		Globals.create_instance(dust, global_position + Vector2(randf_range(-4, 4), randf_range(-4, 4)))
