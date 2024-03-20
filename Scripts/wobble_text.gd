extends Node2D

var time : float = 0
@export var bob_frequency = 4
@export var bob_amplitude = 10
@export var rot_frequency = 4
@export var rot_amplitude = 0.25


func _process(delta):
	time += delta
	var movement = cos(time * bob_frequency) * bob_amplitude
	var rot = cos(time * rot_frequency) * rot_amplitude
	position.y += movement * delta
	rotation += rot * delta
