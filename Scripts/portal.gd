extends Area2D


func _on_area_entered(area):
	get_tree().current_scene.queue_free()
