extends Node2D

var base_health = 10
@onready var health_component = $Area2D
@onready var spawn_timer = $SpawnTimer
@onready var health_bar = $Sprite2D/HealthBar


func _ready():
	spawn_timer.wait_time = Globals.enemy_spawn_controller.get_node("SpawnEnemies").wait_time * 5
	health_component.health = base_health + (Globals.enemy_spawn_controller.spawn_round * 3)
	health_component.max_health = health_component.health
	#health_bar.max_value = health_component.health


func _on_spawn_timer_timeout():
	spawn_enemies(Globals.enemy_spawn_controller.get_enemy_to_spawn(), 1, $SpawnPoint.global_position)


func spawn_enemies(enemy, spawn_amount: int, spawn_position: Vector2):
	for n in spawn_amount:
		var instance = enemy.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = spawn_position
		instance.spawn_floor_y = global_position.y + randf_range(32,-32)
		instance.pipe_spawn = true


func _exit_tree():
	var pipes_left = get_tree().get_nodes_in_group("spawner").size()
