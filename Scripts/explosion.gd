extends Area2D

@export var damage := 10


func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(damage, rotation)


func _on_animated_sprite_2d_animation_finished():
	queue_free()
