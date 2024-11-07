@tool
extends Node2D

@export var radius = 15
@export var color: Color = Color8(57, 57, 57, 255)

func _draw():
	#draw_circle(position, radius+2, Color8(26, 26, 26, 255))
	draw_circle(position, radius, Color8(57, 57, 57, 255))
