extends Node2D

var enemy_to_spawn: PackedScene
var amount_to_spawn = 10


func _ready() -> void:
	for i in amount_to_spawn:
		Globals.enemy_spawn_controller.spawn_enemy(enemy_to_spawn)
	queue_free()
