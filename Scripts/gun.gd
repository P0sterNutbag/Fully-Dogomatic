extends Area2D

class_name Gun

@export_subgroup("Sprite")
#@export var sprite: AnimatedSprite2D  # Model of the weapon
#@export var bullet: String = "res://bullet.tscn"

@export_subgroup("Properties")
@export var bullet: PackedScene = preload("res://Scenes/Bullets/bullet.tscn")
@export var cooldown: float = 1
@export var damage_modifier: float = 0 
@export var spread: float = 0 
@export var shot_count: int = 1 
@export var knockback: int = 15  
@export var rounds: int = 20  
@export var bullet_speed: int = 15 
@export var reload_time: float = 1 
@export var penetrations_modifier: int = 0
@export var distance_to_player = 30
@export var ricochet: bool = false
@export var homing: bool = false

@export_subgroup("Sounds")
@export var sound_shoot: String  # Sound path

var holder = null
var hold_offset: Vector2
var direction_vector: Vector2
var shots_left: int
var flash_timer := 0
var grav_force = -200
var x_force = 0
var game_over = false
var upgrades = 0
var follow_mouse = false
var explode_chance: float = 0

@onready var sprite = $GunFrame
var firepoint
var muzzle_flash
var firepoint_index = 0
var shell = preload("res://Scenes/shell.tscn")
var gun_name = preload("res://Scenes/Guns/gun_name.tscn")
var gun_name_instance: Node2D

#var bullet = preload("res://bullet.tscn")

func _ready():
	x_force = randf_range(-100,100)


func _physics_process(delta):
	if follow_mouse:
		global_position = get_global_mouse_position()
		if holder:
			var dir_to_player = (position - holder.position).normalized()
			hold_offset = dir_to_player * distance_to_player
			rotate_away_from_position(holder.position)
	else:
		if holder != null:
			if not game_over:
				var target_position = holder.position + hold_offset
				position = lerp(position, target_position, 0.25)
			else:
				position += Vector2(x_force * delta, grav_force * delta)
				grav_force += 10
				var rot_dir = 1
				if $PlayerSprite.flip_h:
					rot_dir = -1
				rotate(5 * rot_dir)
				if position.x > 900:
					queue_free()
		#elif Globals.player != null:
			#rotate_away_from_position(Globals.player.position)
	
	if sprite.scale != Vector2(1,1):
		sprite.scale = sprite.scale.lerp(Vector2(1, 1), 6 * delta)


func _process(delta):
	if muzzle_flash:
		if flash_timer > 0:
			muzzle_flash.visible = true
			flash_timer -= delta
		elif muzzle_flash.visible:
			muzzle_flash.visible = false


func rotate_away_from_position(vector: Vector2):
	var dir_to_vector = (position - vector).normalized()
	rotation = dir_to_vector.angle()
	if global_position.x < vector.x:
		scale.y = -1
	else:
		scale.y = 1


func reload():
	Globals.reload_sfx.play()
	$ReloadTimer.start()


func _on_timer_timeout():
	if get_tree().paused: return
	if shots_left > 0 && holder.state != holder.states.dead:
		var b = bullet.instantiate()
		shot_count = b.shot_count
		b.queue_free()
		for i in shot_count:
			var instance = bullet.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = firepoint.global_position
			var accuracy = spread+instance.spread_modifier
			var bullet_angle = rotation + randf_range(-accuracy/100, accuracy/100)
			var bullet_vector = Vector2(cos(bullet_angle), sin(bullet_angle)) * bullet_speed
			instance.move_vector = bullet_vector
			instance.speed = bullet_speed
			instance.rotation = bullet_angle
			instance.damage += damage_modifier
			instance.penetrations += penetrations_modifier
			instance.ricochet = ricochet
			instance.explode_chance = Globals.explode_chance
			instance.homing = homing
			muzzle_flash.visible = true
		position += (direction_vector * -150)
		flash_timer = 1
		shots_left -= 1
		if shots_left <= 0:
			reload()
		var inst = shell.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.global_position = global_position
		inst.max_y = global_position.y+5
		#if cooldown < 0.1:
			#if shots_left % 2 == 1:
				#Globals.shoot_sfx.play()
		#else:
		sprite.scale = Vector2(1.3, 1.3)
		if !Globals.shoot_sfx.is_playing():
			Globals.shoot_sfx.play()
		elif Globals.shoot_sfx.get_playback_position() > 0.05:
			Globals.shoot_sfx.play()


func _on_reload_timer_timeout():
	shots_left = rounds


func set_game_over():
	game_over = true
	$Timer.stop()


func show_name():
	gun_name_instance = gun_name.instantiate()
	get_tree().current_scene.add_child(gun_name_instance)
	var yoffset: int = 30 * sign(Globals.player.global_position.y - global_position.y)
	gun_name_instance.global_position = global_position + Vector2(0, -yoffset)
	gun_name_instance.get_node("RichTextLabel").text = "[center]Grab " + get_meta("Title") + "?"


func reset_material():
	if gun_name_instance != null:
		gun_name_instance.queue_free()
	#sprite.material = null


func _on_setup_timeout():
	setup_gun()


func setup_gun():
	shots_left = rounds
	firepoint = $GunFrame/Barrel/Firepoint
	muzzle_flash = $GunFrame/Barrel/Firepoint/MuzzleFlash
	# Get the children sprites
	#var sprites = get_children()
	## Initialize variables to keep track of maximum width and height
	#var max_width = 0
	#var max_height = 0
	## Iterate through the children sprites to find maximum width and height
	#for s in sprites:
		#if s is Sprite2D:
			## Update max_width if the sprite's width is greater
			#max_width += s.get_texture().get_width()
			## Update max_height if the sprite's height is greater
			#max_height += s.get_texture().get_height()
	## Update the collision shape's size based on the maximum width and height
	#$CollisionShape2D.shape.size = Vector2(max_width, max_height)


func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_tree().paused and !Globals.holding_gun_part and !Globals.settings_open:
			if follow_mouse:
				follow_mouse = false
			else:
				follow_mouse = true
				if not holder:
					attach_to_target(Globals.player)


func attach_to_target(target: Node2D):
	target.gun_pickup.emit()
	target.guns.append(self)
	holder = target
	$Timer.start()
	Globals.world_controller.add_to_gun_list(get_meta("Title"))

