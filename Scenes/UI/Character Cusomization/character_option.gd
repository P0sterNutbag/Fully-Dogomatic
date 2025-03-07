extends UiMenuButton

@onready var circle = $ScaleOffset/Circle
@onready var scale_offset = $ScaleOffset
#@onready var juice = $ScaleOffset/JuicyMovement
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
	tooltip.get_node("RichTextLabel").text = description.to_upper()
	#juice.process_mode = Node.PROCESS_MODE_DISABLED
	$ScaleOffset/UpgradeName.text = "[center]" + character_name.to_upper()
	$ScaleOffset/Sprite2D.texture = sprite
	if !unlocked:
		character_name = "???"
		$ScaleOffset/UpgradeName.text = "[center]" + character_name.to_upper()
		$ScaleOffset/Sprite2D.material = off_shader


func _process(delta: float) -> void:
	if is_hovered() and !has_focus() and abs(Input.get_last_mouse_velocity()) > Vector2.ZERO:
		grab_focus()


func _on_focus_entered():
	if unlocked:
		tooltip.show()
	scale_offset.rotation_degrees = 0
	scale_offset.position = Vector2.ZERO


func _on_focus_exited():
	tooltip.hide()
	scale_offset.rotation_degrees = 0
	scale_offset.position = Vector2.ZERO
