extends Node2D


func _on_restart_pressed():
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")


func _on_quit_button_down():
	get_tree().quit()


func _on_wishlist_pressed():
	var steam_url = "steam://store/2864370"
	OS.shell_open(steam_url)
