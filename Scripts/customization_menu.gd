extends UiMenu


func _ready() -> void:
	super._ready()
	var options = $Options/HBoxContainer.get_children()
	options.append_array($Options/HBoxContainer2.get_children())
	for i in options.size():
		options[i].unlocked = SaveData.get("character"+str(i))


func _on_character_option_pressed() -> void:
	Globals.player_to_spawn = load("res://Scenes/Player/player.tscn")
	SceneManager.start_scene_transition("res://Scenes/Levels/level_select.tscn")


func _on_character_option_2_pressed() -> void:
	if !$Options/HBoxContainer/CharacterOption2.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/dachshund.tscn")
	SceneManager.start_scene_transition("res://Scenes/Levels/level_select.tscn")


func _on_character_option_3_pressed() -> void:
	if !$Options/HBoxContainer/CharacterOption3.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/cat.tscn")
	SceneManager.start_scene_transition("res://Scenes/Levels/level_select.tscn")


func _on_character_option_4_pressed() -> void:
	if !$Options/HBoxContainer2/CharacterOption4.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/terrier.tscn")
	SceneManager.start_scene_transition("res://Scenes/Levels/level_select.tscn")


func _on_character_option_5_pressed() -> void:
	if !$Options/HBoxContainer2/CharacterOption5.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/bulldog.tscn")
	SceneManager.start_scene_transition("res://Scenes/Levels/level_select.tscn")
