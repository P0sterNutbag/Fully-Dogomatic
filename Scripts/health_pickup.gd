extends Area2D

var hp = 50


func _on_area_entered(area):
	var player = area.get_owner()
	if player.hp < player.max_hp:
		player.increase_health(hp)
		queue_free()
