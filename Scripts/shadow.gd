@tool
extends Node2D

@export var radius = 15


func _draw():
	draw_circle(position, radius, Color.BLACK)
