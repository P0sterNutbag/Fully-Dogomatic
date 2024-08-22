extends Control

var target_position: Vector2
@export var offscreen_position_offset = Vector2.UP * 170

func _ready() -> void:
	target_position = position
	position += offscreen_position_offset


func _process(delta: float) -> void:
	position = lerp(position, target_position, 5 * delta)


func float_in():
	target_position = position


func float_out():
	target_position = position + offscreen_position_offset
