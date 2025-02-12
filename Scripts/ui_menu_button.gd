extends Button
class_name UiButton


func _ready():
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(grab_focus)
	mouse_exited.connect(release_focus)
	pressed.connect(_on_pressed)


func _on_pressed():
	AudioManager.select.play()


func _on_focus_entered():
	AudioManager.click.play()


func _on_focus_exited():
	pass
