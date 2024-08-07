extends Control
class_name UiMenu


func _ready():
	get_child(0).get_child(0).grab_focus()

