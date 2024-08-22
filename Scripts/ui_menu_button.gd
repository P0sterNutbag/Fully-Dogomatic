extends Button
class_name UiButton


func _ready():
	focus_entered.connect(on_focus_entered)
	focus_exited.connect(on_focus_exited)
	mouse_entered.connect(grab_focus)
	mouse_exited.connect(release_focus)


func on_focus_entered():
	pass


func on_focus_exited():
	pass
