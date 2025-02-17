extends UiButton
class_name UiMenuButton

@export var scale_target: Control = self
@onready var movement: Node


func _ready():
	mouse_entered.connect(grab_focus)
	focus_entered.connect(grow)
	focus_exited.connect(shrink)
	movement = get_node_or_null("JuicyMovement")
	if movement:
		movement.process_mode = Node.PROCESS_MODE_DISABLED


func grow():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(scale_target, "scale", Vector2.ONE * 1.5, 0.2)
	z_index = 1
	if movement:
		movement.process_mode = Node.PROCESS_MODE_INHERIT


func shrink():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.tween_property(scale_target, "scale", Vector2.ONE, 0.2)
	rotation_degrees = 0
	z_index = 0
	if movement:
		movement.process_mode = Node.PROCESS_MODE_DISABLED


func _on_focus_entered():
	super._on_focus_entered()


func _on_focus_exited():
	super._on_focus_exited()
