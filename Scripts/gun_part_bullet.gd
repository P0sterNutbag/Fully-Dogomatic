extends Node2D

@export_subgroup("Properties")
@export var bullet: PackedScene = preload("res://Scenes/Bullets/bullet.tscn")

var gun_parent


func _ready():
	gun_parent = get_parent().get_parent()
	if gun_parent is Gun:
		gun_parent.bullet = bullet
