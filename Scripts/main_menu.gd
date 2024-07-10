extends Node2D



func _on_play_game_gui_input(event):
	#$MenuDog.target_position = $CanvasLayer/Control/PlayGame.global_position
	if event is InputEventMouseButton:
		get_tree().change_scene_to_file("res://Scenes/Levels/world.tscn")


func _on_wishlist_gui_input(event):
	#$MenuDog.target_position = $CanvasLayer/Control/Wishlist.global_position
	if event is InputEventMouseButton:
		var steam_url = "steam://store/2864370"
		OS.shell_open(steam_url)


func _on_options_gui_input(event):
	pass # Replace with function body.


func _on_quit_gui_input(event):
	#$MenuDog.target_position = $CanvasLayer/Control/Wishlist.global_position
	if event is InputEventMouseButton:
		get_tree().quit()
