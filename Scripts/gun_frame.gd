@tool
extends Node2D

@export_subgroup("Parts")
@export var barrel: PackedScene:
	set(value): 
		barrel_object = set_new_part(barrel_object, value, "", 3)
		barrel = value
		stock = stock
		grip = grip
		magazine = magazine
		sight = sight
		bullet = bullet
@export var stock: PackedScene:
	set(value): 
		stock_object = set_new_part(stock_object, value, "StockSocket", 1)
		stock = value
@export var grip: PackedScene:
	set(value): 
		grip_object = set_new_part(grip_object, value, "GripSocket", 0)
		grip = value
@export var magazine: PackedScene:
	set(value): 
		magazine_object = set_new_part(magazine_object, value, "MagazineSocket", 0)
		magazine = value
@export var sight: PackedScene:
	set(value): 
		sight_object = set_new_part(sight_object, value, "SightSocket", 0)
		sight = value
@export var bullet: PackedScene:
	set(value): 
		bullet_object = set_new_part(bullet_object, value, "", 0)
		bullet = value

var barrel_object: Node2D
var stock_object: Node2D
var grip_object: Node2D
var magazine_object: Node2D
var sight_object: Node2D
var bullet_object: Node2D


func set_new_part(part_object: Node2D, new_part: PackedScene, socket_name: String, z: int):
	if new_part:
		if part_object:
			part_object.queue_free()
		part_object = new_part.instantiate()
		if socket_name != "" and barrel_object:
			barrel_object.get_node(socket_name).add_child(part_object)
		else:
			add_child(part_object)
		part_object.position = Vector2.ZERO
		part_object.z_index = z
		return part_object
	else: 
		if part_object:
			part_object.queue_free()
		return null

func copy_parts(copy_from: Node2D):
	barrel = copy_from.barrel
	grip = copy_from.grip
	magazine = copy_from.magazine
	sight = copy_from.sight
	stock = copy_from.stock
	bullet = copy_from.bullet
