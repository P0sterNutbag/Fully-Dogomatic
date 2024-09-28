extends Node2D

var pause_controller = preload("res://Scenes/UI/pause_controller.tscn")


func _ready():
	AudioManager.menu_music.play()
	Globals.create_instance(pause_controller, Vector2.ZERO, get_tree().root)


func _on_play_pressed():
	SceneManager.start_scene_transition("res://Scenes/Levels/customize.tscn", false)


func _on_options_pressed():
	get_tree().root.get_node("PauseController").pause_game()


func _on_wishlist_pressed():
	var steam_url = "steam://store/2864370"
	OS.shell_open(steam_url)


func _on_quit_pressed():
	get_tree().quit()
