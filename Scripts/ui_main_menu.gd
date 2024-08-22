extends Node2D


func _ready():
	AudioManager.menu_music.play()


func _on_play_pressed():
	SceneManager.start_scene_transition("res://Scenes/Levels/customize.tscn")


func _on_options_pressed():
	$GameController.pause_game()


func _on_wishlist_pressed():
	var steam_url = "steam://store/2864370"
	OS.shell_open(steam_url)


func _on_quit_pressed():
	get_tree().quit()
