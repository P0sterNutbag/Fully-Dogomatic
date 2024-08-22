extends UiButton

@onready var circle = $ScaleOffset/Circle
@onready var scale_offset = $ScaleOffset
@onready var juice = $ScaleOffset/JuicyMovement
@export var character_name: String = "Corgi" : 
	set(value):
		$ScaleOffset/UpgradeName.text = "[center]" + value
@export var sprite: Texture :
	set(value):
		$ScaleOffset/Sprite2D.texture = value
var target_scale: float = 1


func _ready() -> void:
	super._ready()
	juice.process_mode = Node.PROCESS_MODE_DISABLED
	#position_origin = position


func _process(delta: float) -> void:
	scale_offset.scale = lerp(scale_offset.scale, Vector2.ONE * target_scale, 10 * delta)
	if is_hovered() and !has_focus() and abs(Input.get_last_mouse_velocity()) > Vector2.ZERO:
		grab_focus()


func on_focus_entered():
	super.on_focus_entered()
	scale_up()
	circle.queue_redraw()
	juice.process_mode = Node.PROCESS_MODE_PAUSABLE
	z_index += 1


func on_focus_exited():
	super.on_focus_exited()
	scale_down()
	circle.queue_redraw()
	juice.process_mode = Node.PROCESS_MODE_DISABLED
	scale_offset.position = Vector2.ZERO
	scale_offset.rotation_degrees = 0
	z_index -= 1


func scale_up():
	target_scale = 1.5


func scale_down():
	target_scale = 1
