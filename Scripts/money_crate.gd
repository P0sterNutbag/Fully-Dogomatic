extends Node2D

var money = preload("res://Scenes/Player/dollar.tscn")
var money_chance = 0.25
@export var money_amount: int = 5


func _exit_tree() -> void:
	if randf_range(0, 1) < money_chance:
		#money_amount = money_amount / Globals.enemy_spawn_controller.spawn_time[Globals.enemy_spawn_controller.spawn_round] * 2
		for i in money_amount:
			Globals.create_instance(money, global_position + Vector2(randi_range(24,-24),randi_range(24,-24)))
