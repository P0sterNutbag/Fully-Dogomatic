extends Boss

@export var spawn_amount = 5
var enemy_to_spawn = preload("res://Scenes/Enemies/enemy_small_flyer.tscn")


func _on_spawn_enemies_timeout() -> void:
	for i in spawn_amount:
		var inst = enemy_to_spawn.instantiate() 
		inst.global_position = global_position + Vector2(randf_range(-32,32),randf_range(-32,32))
		get_tree().current_scene.add_child(inst)
