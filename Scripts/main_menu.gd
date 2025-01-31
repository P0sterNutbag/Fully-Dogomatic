extends Node2D

var credits = preload("res://Scenes/Levels/credits.tscn")
@onready var dogs = [$MenuDog, $MenuDog2, $MenuDog3, $MenuDog4, $MenuDog5]


func _ready():
	for i in dogs.size():
		dogs[i].visible = SaveData.get("character"+str(i))
	AudioManager.menu_music.play()


func _on_play_pressed():
	SceneManager.start_scene_transition("res://Scenes/Levels/customize.tscn", false)


func _on_options_pressed():
	get_tree().root.get_node("PauseController").pause_game()


func _on_credits_pressed() -> void:
	var inst = credits.instantiate()
	get_tree().root.add_child(inst)
	visible = false
	get_tree().paused = true


func _on_quit_pressed():
	get_tree().quit()


func _on_test_pressed() -> void:
	SceneManager.start_scene_transition("res://Scenes/Levels/test.tscn", false)
