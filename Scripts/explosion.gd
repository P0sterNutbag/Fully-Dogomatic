extends Area2D

@export var damage := 10
var damage_number = preload("res://Scenes/Particles/damage_number.tscn")

func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(damage, rotation)
		var instance = damage_number.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = area.global_position + Vector2.UP * 8
		instance.get_node("Text").text += str(damage)


func _on_animated_sprite_2d_animation_finished():
	queue_free()
