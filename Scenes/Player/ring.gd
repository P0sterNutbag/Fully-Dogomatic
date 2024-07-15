extends Node2D

@export var circle_radius = 64
@export var outline_thickness = 2
@export var color: PackedColorArray

func _draw():
	var circle_points = Globals.generate_circle_points(position, circle_radius, 360)
	draw_polyline_colors(circle_points, color, outline_thickness)
