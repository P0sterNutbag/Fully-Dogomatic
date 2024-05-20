extends Area2D

var damage := 5


func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(damage)


func _on_animated_sprite_2d_animation_finished():
	queue_free()
