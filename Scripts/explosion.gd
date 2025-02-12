extends Area2D

@export var damage: float = 3
var knockback_force: float
var has_made_number: bool
var damage_number = preload("res://Scenes/Particles/damage_number.tscn")


func _enter_tree() -> void:
	$AnimatedSprite2D.play("default")


func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(damage, 0)
		var instance = damage_number.instantiate()
		if knockback_force > 0 and area.get_parent() is Enemy:
			area.get_parent().knockback((area.get_parent().global_position - global_position).normalized() * knockback_force)
		if has_made_number:
			return
		get_tree().current_scene.add_child(instance)
		instance.global_position = global_position
		instance.get_node("Text").text += str(damage)
		has_made_number = true


func _on_animated_sprite_2d_animation_finished():
	get_parent().call_deferred("remove_child", self)
