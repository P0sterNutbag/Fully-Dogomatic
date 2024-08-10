extends Button

func _ready():
	mouse_entered.connect(grab_focus)
	mouse_exited.connect(release_focus)
	
