extends Node2D

@export var enemies_to_spawn: Array[PackedScene]
var amount_to_spawn = 10


func _ready() -> void:
	var enemy_to_spawn = enemies_to_spawn[randi_range(0, enemies_to_spawn.size()-1)]
	for i in amount_to_spawn:
		Globals.enemy_spawn_controller.spawn_enemy(enemy_to_spawn)
	queue_free()
