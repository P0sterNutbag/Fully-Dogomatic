extends Control
class_name UiMenu

@export var first_button: Button

func _ready():
	if first_button:
		first_button.grab_focus()
	else:
		get_child(0).get_child(0).grab_focus()
