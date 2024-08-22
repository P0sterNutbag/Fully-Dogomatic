@tool
extends Control

@export var circle_radius = 64
@export var outline_thickness = 2
@export var circle_texture: Texture
@export var outline_texture: Texture


func _draw():
	if owner.has_focus():
		draw_option_outline()
	draw_option_circle()


func draw_option_circle():
	var circle_points = Globals.generate_circle_points(position, circle_radius, 360)
	draw_colored_polygon(circle_points, Color.RED, circle_points, circle_texture)


func draw_option_outline():
	var outline_points = Globals.generate_circle_points(position, circle_radius+outline_thickness, 360)
	draw_colored_polygon(outline_points, Color.BLACK, outline_points, outline_texture)


func _on_upgrade_option_focus_entered():
	queue_redraw()


func _on_upgrade_option_focus_exited():
	queue_redraw()
