extends Node2D


@export var part: PackedScene
var follow_mouse: bool = false
var my_gun: Node2D = null
var type: String 
var target_position: Vector2
var last_part: PackedScene
var last_gun: Node2D
@onready var arrow = $Arrow
@onready var part_sprite = $Sprite2D


func set_sprite():
	var inst = part.instantiate()
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = inst.region_rect
	set_meta("Title", inst.get_meta("Title"))
	set_meta("Type", inst.get_meta("Type"))
	inst.queue_free()
	target_position = Globals.player.global_position + Vector2.RIGHT * 32


func _process(delta):
	# follow mouse
	if follow_mouse:
		var closest_gun
		if abs(Input.get_last_mouse_velocity()) > Vector2.ZERO:
			target_position = get_global_mouse_position()
		if abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_X)) > InputController.axis_threshold or abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)) > InputController.axis_threshold:
			target_position = Globals.player.global_position + Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)).normalized() * 32
		elif Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
			if Globals.player.guns.size() > 1:
				closest_gun = find_nearest_gun(target_position)
				var i = 0
				target_position = closest_gun.global_position - Globals.player.global_position
				while find_nearest_gun(target_position) == closest_gun:
					target_position = (closest_gun.global_position - Globals.player.global_position).rotated(Input.get_axis("left", "right") * i) 
					i += 1
					if i > 360:
						return
		closest_gun = find_nearest_gun(target_position)
		if closest_gun != last_gun:
			add_part_to_gun(closest_gun, part)
			if last_gun != null:
				add_part_to_gun(last_gun, last_gun.get_node("GunFrame").last_changed_part)
		var dest = closest_gun.global_position + (closest_gun.global_position - Globals.player.global_position).normalized() * 32
		arrow.global_position = lerp(arrow.global_position, dest, 10 * delta)
		arrow.look_at(closest_gun.global_position)
		Globals.holding_gun_part = true
		# attach to gun
		if Input.is_action_just_pressed("select"):
			if closest_gun != null:
				add_part_to_gun(closest_gun, part)
				Globals.upgrade_menu.finish()
				queue_free()
		last_gun = closest_gun
	# find nearest gun
	#var closest_dist = 1000
	#for gun in Globals.player.guns:
		#var dist = global_position.distance_to(gun.global_position)
		#if dist < closest_dist and dist < 8:
			#closest_dist = dist
			#my_gun = gun


func find_nearest_gun(pos: Vector2) -> Node2D:
	var closest_dis = 1000
	var closest_gun: Node2D
	for gun in Globals.player.guns:
		var dis = gun.global_position.distance_to(pos)
		if dis < closest_dis:
			closest_dis = dis
			closest_gun = gun
	return closest_gun


func _exit_tree():
	Globals.holding_gun_part = false


func attach_to_target(_object: Node2D):
	follow_mouse = true
	part_sprite.visible = false
	arrow.visible = true


func add_part_to_gun(gun_to_change: Node2D, new_part: PackedScene):
	var inst = new_part.instantiate()
	var gun_frame = gun_to_change.get_node("GunFrame")
	gun_frame.last_changed_part = PackedScene.new()
	if inst:
		if inst.name.contains("Barrel"): 
			gun_frame.last_changed_part.pack(gun_frame.barrel_object)
			gun_frame.barrel = new_part
		elif inst.name.contains("Grip"): 
			gun_frame.last_changed_part.pack(gun_frame.grip_object)
			gun_frame.grip = new_part
		elif inst.name.contains("Magazine"): 
			gun_frame.last_changed_part.pack(gun_frame.magazine_object)
			gun_frame.magazine = new_part
		elif inst.name.contains("Scope"): 
			gun_frame.last_changed_part.pack(gun_frame.sight_object)
			gun_frame.sight = new_part
		elif inst.name.contains("Stock"): 
			gun_frame.last_changed_part.pack(gun_frame.stock_object)
			gun_frame.stock = new_part
	#gun_frame.set_stats()
	inst.queue_free()
