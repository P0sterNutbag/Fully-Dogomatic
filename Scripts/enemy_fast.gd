extends Enemy


func _on_hitbox_area_entered(area):
	if area.name == "Hurtbox":
		$Hurtbox.take_damage($Hurtbox.health, 0)
