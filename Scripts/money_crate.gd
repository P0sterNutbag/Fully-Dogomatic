extends Area2D

var money = preload("res://Scenes/Player/dollar.tscn")


func _on_area_entered(area: Area2D) -> void:
	for i in randi_range(10, 15):
		Globals.create_instance(money, global_position + Vector2(randf_range(-16, 16), randf_range(-16, 16)))
	queue_free()
