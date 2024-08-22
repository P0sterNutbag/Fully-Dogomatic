extends UiMenu


func _ready() -> void:
	super._ready()


func _on_character_option_pressed() -> void:
	SceneManager.start_scene_transition("res://Scenes/Levels/world.tscn")
