extends Node2D

@onready var pause_menu = $PauseMenu


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pause_game()


func pause_game():
	if not get_tree().paused:
		get_tree().paused = true
		pause_menu.visible = true
	else:
		get_tree().paused = false
		pause_menu.visible = false
