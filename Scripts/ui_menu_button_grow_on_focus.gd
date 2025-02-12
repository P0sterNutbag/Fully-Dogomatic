extends UiButton
class_name UiMenuButton


func _ready():
	mouse_entered.connect(grab_focus)
	focus_entered.connect(grow)
	focus_exited.connect(shrink)


func grow():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ONE * 1.5, 0.2)
	z_index = 1


func shrink():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ONE, 0.2)
	z_index = 0


func _on_focus_entered():
	super._on_focus_entered()


func _on_focus_exited():
	super._on_focus_exited()
