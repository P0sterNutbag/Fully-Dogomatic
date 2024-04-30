extends Node2D


@export var part: PackedScene
var follow_mouse: bool = false
var my_gun: Node2D = null
var type: String 


func set_sprite():
	var inst = part.instantiate()
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = inst.region_rect
	set_meta("Title", inst.get_meta("Title"))
	set_meta("Type", inst.get_meta("Type"))
	inst.queue_free()


func _process(_delta):
	# follow mouse
	if follow_mouse:
		global_position = get_global_mouse_position()
		Globals.holding_gun_part = true
		# attach to gun
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if my_gun != null:
				var inst = part.instantiate()
				if inst.name.contains("Barrel"): my_gun.get_node("GunFrame").barrel = part
				elif inst.name.contains("Grip"): my_gun.get_node("GunFrame").grip = part
				elif inst.name.contains("Magazine"): my_gun.get_node("GunFrame").magazine = part
				elif inst.name.contains("Scope"): my_gun.get_node("GunFrame").sight = part
				elif inst.name.contains("Stock"): my_gun.get_node("GunFrame").stock = part
				my_gun.get_node("GunFrame").set_stats()
				inst.queue_free()
				queue_free()
	# find nearest gun
	var closest_dist = 1000
	for gun in Globals.player.guns:
		var dist = global_position.distance_to(gun.global_position)
		if dist < closest_dist and dist < 8:
			closest_dist = dist
			my_gun = gun


# func _on_input_event(_viewport, event, _shape_idx):
# 	if follow_mouse and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
# 		print_debug(my_gun)
# 		if my_gun != null:
# 			my_gun.get_node("GunFrame").barrel = part
# 			queue_free()


func _exit_tree():
	Globals.holding_gun_part = false

# func _on_area_entered(area: Area2D):
# 	if area.is_in_group("gun"):
# 		my_gun = area


func attach_to_target(_object: Node2D):
	pass
