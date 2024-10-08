extends Node2D

var amount_to_spawn = 10
var enemy_to_spawn = preload("res://Scenes/Enemies/enemy_speedy.tscn")

func _ready() -> void:
	for i in amount_to_spawn:
		Globals.enemy_spawn_controller.spawn_enemy(enemy_to_spawn)
	queue_free()
