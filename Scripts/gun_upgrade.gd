extends Node2D
class_name GunUpgrade

@export var upgrade_values: Array[VariableChange]
var follow_mouse: bool = false
var target_position: Vector2
var closest_gun: Node2D
@onready var arrow = $Arrow
@onready var arrow_text = $Label
@onready var upgrade_sprite = $UpgradeSprite


func ready():
	target_position = Globals.player.global_position + Vector2.RIGHT * 32


func _process(delta):
	if follow_mouse:
		# get closest gun
		if abs(Input.get_last_mouse_velocity()) > Vector2.ZERO:
			target_position = get_global_mouse_position()
		if abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_X)) > InputController.axis_threshold or abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)) > InputController.axis_threshold:
			target_position = Globals.player.global_position + Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)).normalized() * 32
		elif Input.is_action_just_pressed("right") or Input.is_action_just_pressed("left"):
			if Globals.player.guns.size() > 1:
				#var closest_gun = find_nearest_gun(target_position)
				#$RayCast2D.global_position = Globals.player.global_position
				#$RayCast2D.rotation = (closest_gun.global_position - Globals.player.global_position).angle()
				#for i in 360:
					#$RayCast2D.rotate(deg_to_rad(sign(Input.get_axis("left", "right"))))
					#var new_gun = $RayCast2D.get_collider()
					#if new_gun != closest_gun:
						#target_position = new_gun.global_position
						#break
				closest_gun = find_nearest_gun(target_position)
				var i = 1
				target_position = Globals.player.global_position + (closest_gun.global_position - Globals.player.global_position)
				while find_nearest_gun(target_position) == closest_gun:
					target_position = (Globals.player.global_position + (closest_gun.global_position - Globals.player.global_position).rotated(Input.get_axis("left", "right") * deg_to_rad(i))) 
					#target_position = Globals.player.global_position + (Vector2.RIGHT * 30).rotated(Input.get_axis("left", "right") * deg_to_rad(i)) 
					i += 1
					if i > 360:
						break
		closest_gun = find_nearest_gun(target_position)
		
		# move arrow to closest gun
		var dest = closest_gun.global_position + (closest_gun.global_position - Globals.player.global_position).normalized() * 32
		arrow.global_position = lerp(arrow.global_position, dest, 10 * delta)
		arrow.look_at(closest_gun.global_position)
		arrow_text.text = "[center]" + closest_gun.get_meta("Title")
		arrow_text.global_position = arrow.global_position + Vector2(-50, 8)
		arrow_text.rotation_degrees = 0
		# attach to gun
		if Input.is_action_just_pressed("select"):
			if closest_gun != null:
				add_upgrade_to_gun(closest_gun)
				Globals.upgrade_menu.finish()
				queue_free()


func find_nearest_gun(pos: Vector2) -> Node2D:
	var closest_dis = 1000
	var nearest_gun: Node2D
	for gun in Globals.player.guns:
		var dis = gun.global_position.distance_to(pos)
		if dis < closest_dis:
			closest_dis = dis
			nearest_gun = gun
	return nearest_gun


func attach_to_target(_object: Node2D):
	follow_mouse = true
	upgrade_sprite.visible = false
	arrow.visible = true
	arrow_text.visible = true


func add_upgrade_to_gun(gun_to_change: Node2D):
	for variable_change in upgrade_values:
		if variable_change.add_value:
			gun_to_change.set(variable_change.values[0], gun_to_change.get(variable_change.values[0]) + variable_change.values[1])
		elif variable_change.multiply_value:
			gun_to_change.set(variable_change.values[0], gun_to_change.get(variable_change.values[0]) * variable_change.values[1])
		else:
			gun_to_change.set(variable_change.values[0], variable_change.values[1])
	#var text = gun_to_change.loadout_text.get_node("RichTextLabel")
	#text.text += "\n" + " " + get_meta("Title")
	#text.custom_minimum_size.y += 9
