extends UiButton

@onready var circle = $ScaleOffset/Circle
@onready var scale_offset = $ScaleOffset
@onready var juice = $ScaleOffset/JuicyMovement
@onready var tooltip = $Tooltip
@onready var description_text = $Tooltip/RichTextLabel
@export var character_name: String
@export var description: String
@export var sprite: Texture
@export var unlocked: bool:
	set(value):
		unlocked = value
		if !value:
			character_name = "???"
			$ScaleOffset/UpgradeName.text = "[center]" + character_name.to_upper()
			$ScaleOffset/Sprite2D.material = off_shader
var off_shader = preload("res://Art/Shaders/color_change.tres")
var target_scale: float = 1


func _ready() -> void:
	super._ready()
	juice.process_mode = Node.PROCESS_MODE_DISABLED
	$ScaleOffset/UpgradeName.text = "[center]" + character_name.to_upper()
	$ScaleOffset/Sprite2D.texture = sprite
	if !unlocked:
		character_name = "???"
		$ScaleOffset/UpgradeName.text = "[center]" + character_name.to_upper()
		$ScaleOffset/Sprite2D.material = off_shader


func _process(delta: float) -> void:
	scale_offset.scale = lerp(scale_offset.scale, Vector2.ONE * target_scale, 10 * delta)
	if is_hovered() and !has_focus() and abs(Input.get_last_mouse_velocity()) > Vector2.ZERO:
		grab_focus()


func _on_focus_entered():
	super._on_focus_entered()
	scale_up()
	circle.queue_redraw()
	juice.process_mode = Node.PROCESS_MODE_PAUSABLE
	if unlocked:
		tooltip.visible = true
		description_text.text = "[center]" + description.to_upper()
	z_index += 1


func _on_focus_exited():
	super._on_focus_exited()
	scale_down()
	circle.queue_redraw()
	juice.process_mode = Node.PROCESS_MODE_DISABLED
	scale_offset.position = Vector2.ZERO
	scale_offset.rotation_degrees = 0
	description_text.text = ""
	tooltip.visible = false
	z_index -= 1


func scale_up():
	target_scale = 1.5


func scale_down():
	target_scale = 1
