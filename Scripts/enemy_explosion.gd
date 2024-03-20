extends AnimatedSprite2D

var damage = 10
var has_damaged_player = false

func _on_animation_finished():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.name == "Hurtbox":
		if !has_damaged_player:
			area.get_parent().take_damage(damage)
			has_damaged_player = true
