extends Control

@export var gui_layer: CanvasLayer
const position_offset = Vector2(10, 10)
var gun: Node2D


func _ready():
	Globals.gunstats = self


func _process(delta):
	if visible:
		position = get_global_mouse_position() + position_offset
