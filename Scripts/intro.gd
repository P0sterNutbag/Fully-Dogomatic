extends Node2D

#var next_scene = preload("res://Scenes/Levels/main_menu.tscn")
#var menu
@onready var logo = $CanvasLayer/Logo


func _ready():
	#menu = get_tree().root.get_node("MainMenu")
	await get_tree().create_timer(0.75).timeout
	var tween = create_tween()
	tween.tween_property(logo, "modulate:a", 0, 0.5)
	tween.tween_callback(finish)


func _process(_delta):
	if Input.is_action_just_pressed("select"):
		finish()


func finish():
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
	#menu.process_mode = Node.PROCESS_MODE_PAUSABLE
	#menu.start()
	#await get_tree().create_timer(0.01).timeout
	#queue_free()
