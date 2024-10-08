extends AnimatedSprite2D

var damage = 10
var has_damaged_player = false


func _on_animation_finished():
	queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		if !has_damaged_player:
			area.get_parent().take_damage(damage)
			has_damaged_player = true
	elif area.is_in_group("enemy"):
		area.take_damage(damage, 0)
