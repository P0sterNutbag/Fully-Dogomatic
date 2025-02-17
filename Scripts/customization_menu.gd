extends UiMenu


func _ready() -> void:
	super._ready()
	var options = $Options.get_children()
	for i in options.size():
		options[i].unlocked = SaveData.get("character"+str(i))


func _on_character_option_pressed() -> void:
	Globals.player_to_spawn = load("res://Scenes/Player/player.tscn")
	change_scene()


func _on_character_option_2_pressed() -> void:
	if !$Options/CharacterOption2.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/dachshund.tscn")
	change_scene()


func _on_character_option_3_pressed() -> void:
	if !$Options/CharacterOption3.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/cat.tscn")
	change_scene()


func _on_character_option_4_pressed() -> void:
	if !$Options/CharacterOption4.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/terrier.tscn")
	change_scene()


func _on_character_option_5_pressed() -> void:
	if !$Options/CharacterOption5.unlocked:
		return
	Globals.player_to_spawn = load("res://Scenes/Player/bulldog.tscn")
	change_scene()


func change_scene() -> void:
	if !SaveData.completed:
		SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")
	else:
		var difficulty = get_parent().get_node("Difficulty")
		var tween = create_tween().set_trans(Tween.TRANS_EXPO)
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(self, "global_position", Vector2.DOWN*360, 0.5)
		tween.tween_callback(difficulty.move_in)
		tween.tween_property(self, "process_mode", PROCESS_MODE_DISABLED, 0)
