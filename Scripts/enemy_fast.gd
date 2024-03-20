extends "res://Scripts/enemy.gd"


func _on_hitbox_area_entered(area):
	if area.name == "Hurtbox":
		area.get_parent().take_damage(damage)
		take_damage(health)
