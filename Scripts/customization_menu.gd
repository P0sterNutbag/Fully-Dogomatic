extends UiMenu


func _ready() -> void:
	super._ready()


func _on_character_option_pressed() -> void:
	Globals.player_to_spawn = load("res://Scenes/Player/player.tscn")
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")


#func _on_character_option_2_pressed() -> void:
	#Globals.player_to_spawn = load("res://Scenes/Player/dachshund.tscn")
	#SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")
#
#
#func _on_character_option_3_pressed() -> void:
	#Globals.player_to_spawn = load("res://Scenes/Player/terrier.tscn")
	#SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")
#
#
#func _on_character_option_4_pressed() -> void:
	#Globals.player_to_spawn = load("res://Scenes/Player/cat.tscn")
	#SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")
