extends Area2D

@export var explosion = preload("res://Scenes/Particles/explosion.tscn")


func _on_area_entered(area: Area2D) -> void:
	queue_free()


func _exit_tree() -> void:
	Globals.create_instance(explosion, global_position)
