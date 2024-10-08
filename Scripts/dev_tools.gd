extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_tree().current_scene == Globals.world_controller:
		if Input.is_action_just_pressed("bark"):
			Globals.level_manager.spawn_level_objects()
	
	if Input.is_key_pressed(KEY_1):
		Globals.enemy_spawn_controller.spawn_round = 1
	elif Input.is_key_pressed(KEY_2):
		Globals.enemy_spawn_controller.spawn_round = 2
	elif Input.is_key_pressed(KEY_3):
		Globals.enemy_spawn_controller.spawn_round = 3
	elif Input.is_key_pressed(KEY_4):
		Globals.enemy_spawn_controller.spawn_round = 4
	elif Input.is_key_pressed(KEY_5):
		Globals.enemy_spawn_controller.spawn_round = 5
	elif Input.is_key_pressed(KEY_6):
		Globals.enemy_spawn_controller.spawn_round = 6
	elif Input.is_key_pressed(KEY_7):
		Globals.enemy_spawn_controller.spawn_round = 7
	elif Input.is_key_pressed(KEY_8):
		Globals.enemy_spawn_controller.spawn_round = 8
	elif Input.is_key_pressed(KEY_9):
		Globals.enemy_spawn_controller.spawn_round = 9
