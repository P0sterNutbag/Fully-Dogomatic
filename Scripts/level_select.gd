extends UiMenu


func _ready():
	super._ready()
	var options = $Control.get_children()
	for i in options.size():
		options[i].unlocked = SaveData.get("stage"+str(i))
		options[i].best_time = SaveData.get("stage"+str(i)+"time")


func _on_level_button_pressed() -> void:
	Globals.current_level = "res://Scenes/Levels/world_endless1.tscn"
	SceneManager.start_scene_transition("res://Scenes/Levels/world_endless1.tscn")


func _on_level_button_2_pressed() -> void:
	if !$Control/LevelButton2.unlocked:
		return
	Globals.current_level = "res://Scenes/Levels/world_endless2.tscn"
	SceneManager.start_scene_transition("res://Scenes/Levels/world_endless2.tscn")


func _on_level_button_3_pressed() -> void:
	if !$Control/LevelButton3.unlocked:
		return
	Globals.current_level = "res://Scenes/Levels/world_endless3.tscn"
	SceneManager.start_scene_transition("res://Scenes/Levels/world_endless3.tscn")
