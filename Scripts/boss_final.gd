extends Boss

var win_screen = preload("res://Scenes/Levels/win_screen.tscn")


func on_death(bullet_direction: float = 0):
	#Globals.enemy_spawn_controller.process_mode = PROCESS_MODE_DISABLED
	Globals.set_achievement("win_game")
	Globals.create_instance(cutscene)
	#super.on_death()
