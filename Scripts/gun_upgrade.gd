extends Node2D
class_name GunUpgrade

@export var upgrade_values: Array[VariableChange]
@export var increase_upgrades: bool = true
var follow_mouse: bool = false
var gun_index: int
var target_position: Vector2
var closest_gun: Node2D
var alert = preload("res://Scenes/UI/not_enough_money.tscn")
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
		if Input.is_action_just_pressed("left"):
			if Globals.player.guns.size() > 1:
				gun_index = wrapi(gun_index + 1, 0, Globals.player.guns.size())
				target_position = Globals.player.guns[gun_index].global_position
		elif Input.is_action_just_pressed("right"):
				gun_index = wrapi(gun_index - 1, 0, Globals.player.guns.size())
				target_position = Globals.player.guns[gun_index].global_position
		elif Input.is_action_just_pressed("back"):
			Globals.upgrade_menu.refund()
			queue_free()
		closest_gun = find_nearest_gun(target_position)
		
		# move arrow to closest gun
		var dest = closest_gun.global_position + (closest_gun.global_position - Globals.player.global_position).normalized() * 32
		arrow.global_position = lerp(arrow.global_position, dest, 10 * delta)
		arrow.look_at(closest_gun.global_position)
		arrow_text.text = "[center]" + closest_gun.get_meta("Title") + "\n" + str(closest_gun.upgrades) + "/" + str(closest_gun.max_upgrades)
		arrow_text.global_position = arrow.global_position + Vector2(-50, 8)
		arrow_text.rotation_degrees = 0
		# attach to gun
		if Input.is_action_just_pressed("select"):
			if closest_gun != null:
				if closest_gun.upgrades < closest_gun.max_upgrades or !increase_upgrades:
					add_upgrade_to_gun(closest_gun)
					Globals.upgrade_menu.finish()
					queue_free()
				else:
					var inst = Globals.create_instance(alert, arrow.global_position + Vector2.UP * 16)
					inst.get_node("RichTextLabel").text = "[center]Upgrade Cap Reached"


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
	Globals.player.sort_gun_array()
	closest_gun = find_nearest_gun(Globals.player.global_position + Vector2.RIGHT * 32)
	target_position = closest_gun.global_position
	gun_index = Globals.player.guns.find(closest_gun)


func add_upgrade_to_gun(gun_to_change: Node2D):
	for variable_change in upgrade_values:
		if variable_change.add_value:
			gun_to_change.set(variable_change.values[0], gun_to_change.get(variable_change.values[0]) + variable_change.values[1])
		elif variable_change.multiply_value:
			gun_to_change.set(variable_change.values[0], gun_to_change.get(variable_change.values[0]) * variable_change.values[1])
		else:
			gun_to_change.set(variable_change.values[0], variable_change.values[1])
	if increase_upgrades:
		gun_to_change.upgrades += 1
	if gun_to_change.upgrades >= 5:
		Globals.set_achievement("upgrade_gun")
	#var text = gun_to_change.loadout_text.get_node("RichTextLabel")
	#text.text += "\n" + " " + get_meta("Title")
	#text.custom_minimum_size.y += 9
