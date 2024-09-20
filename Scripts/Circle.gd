@tool
extends Control

@export var circle_radius = 64
@export var outline_thickness = 2


func _draw():
	#if owner.has_focus():
	draw_option_outline()
	draw_option_circle()


func draw_option_circle():
	draw_circle(position, circle_radius, Color.RED)


func draw_option_outline():
	draw_circle(position, circle_radius+outline_thickness, Color.BLACK)


func _on_upgrade_option_focus_entered():
	queue_redraw()


func _on_upgrade_option_focus_exited():
	queue_redraw()
