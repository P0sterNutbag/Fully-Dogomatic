extends Area2D

class_name Gun

@export_subgroup("Sprite")
#@export var sprite: AnimatedSprite2D  # Model of the weapon
#@export var bullet: String = "res://bullet.tscn"

@export_subgroup("Properties")
@export var bullet: PackedScene = preload("res://Scenes/Bullets/bullet.tscn")
@export var cooldown: float = 1:
	set(value): 
		cooldown = value
		$Timer.wait_time = value
@export var spread: float = 0 
@export var shot_count: int = 1 
@export var knockback: int = 15  
@export var rounds: int = 20  
@export var bullet_speed: int = 15 
@export var reload_time: float = 1: 
	set(value): 
		reload_time = value
		$ReloadTimer.wait_time = reload_time
@export var penetrations: int = 1
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
var locked: bool = false
var is_mouse_entered: bool = false
var aim_dir := Vector2.RIGHT
var can_delete: bool = false
var muzzleflash_textures = [preload("res://Art/Sprites/muzzleflash.png"), 
preload("res://Art/Sprites/muzzleflash2.png"),
preload("res://Art/Sprites/muzzleflash3.png")]

@onready var sprite = $GunFrame
var firepoint
var muzzle_flash
var firepoint_index = 0
var shell = preload("res://Scenes/Particles/shell.tscn")
#var gun_name = preload("res://Scenes/Guns/gun_name.tscn")
var status_effect = preload("res://Scenes/Particles/gun_status.tscn")
var gun_name_instance: Node2D
var bullet_damage: float
var bullet_explosion: PackedScene
var can_press: bool
var gunshot_sfx: AudioStreamPlayer2D
signal gun_deleted


func _ready():
	x_force = randf_range(-100,100)


func _physics_process(delta):
	if follow_mouse:
		if abs(Input.get_last_mouse_velocity()) > Vector2.ZERO:
			aim_dir = (get_global_mouse_position() - get_parent().global_position).normalized()
		if abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_X)) > InputController.axis_threshold or abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)) > InputController.axis_threshold:
			aim_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)).normalized()
		elif abs(Input.get_axis("left", "right")) > 0:
			aim_dir = aim_dir.rotated(Input.get_axis("left", "right") * 3 * delta)
		elif abs(Input.get_axis("up", "down")) > 0:
			aim_dir = aim_dir.rotated(Input.get_axis("up", "down") * 3 * delta)
		global_position = lerp(global_position, Globals.player.global_position + aim_dir * distance_to_player * 1.5, delta * 10)
		global_rotation = aim_dir.angle()
		if global_position.x < holder.global_position.x:
			scale.y = -1
		else:
			scale.y = 1
		#rotate_away_from_position(holder.position)
	else:
		if holder != null:
			if not game_over:
				position = lerp(position, aim_dir * distance_to_player, delta * 10)
			else:
				position += Vector2(x_force * delta, grav_force * delta)
				grav_force += 10
				var rot_dir = 1
				if $PlayerSprite.flip_h:
					rot_dir = -1
				rotate(5 * rot_dir)
				if position.x > 900:
					queue_free()
	if sprite.scale != Vector2(1,1):
		sprite.scale = sprite.scale.lerp(Vector2(1, 1), 6 * delta)


func _process(delta):
	if muzzle_flash:
		if flash_timer > 0:
			muzzle_flash.visible = true
			flash_timer -= delta
		elif muzzle_flash.visible:
			muzzle_flash.visible = false
	if Input.is_action_just_pressed("select") and can_press:
		if can_delete and is_mouse_entered:
			gun_deleted.emit()
			Globals.player.guns.erase(self)
			queue_free()
		if follow_mouse:
			follow_mouse = false
			Globals.upgrade_menu.finish()
	can_press = true


func rotate_away_from_position(vector: Vector2):
	var dir_to_vector = (position - vector).normalized()
	rotation = dir_to_vector.angle()
	if global_position.x < vector.x:
		scale.y = -1
	else:
		scale.y = 1


func reload():
	$ReloadTimer.start()
	spin_gun()
	var status_effect = Globals.create_instance(status_effect, global_position + Vector2(0, -8))


func _on_timer_timeout(): # shoot bullets
	if get_tree().paused: return
	if shots_left > 0 && holder.state != holder.states.dead:
		var accuracy_mod = -5
		if abs(Globals.player.velocity) > Vector2.ZERO:
			accuracy_mod = 3
		for i in shot_count:
			var instance = bullet.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = firepoint.global_position
			var accuracy = clamp(spread + instance.spread_modifier + accuracy_mod, 0, 100)
			var bullet_angle = global_rotation + randf_range(-accuracy/100, accuracy/100)
			var bullet_vector = Vector2(cos(bullet_angle), sin(bullet_angle)) * bullet_speed
			instance.move_vector = bullet_vector
			instance.speed = bullet_speed
			instance.global_rotation = bullet_angle
			instance.damage  = bullet_damage
			instance.penetrations = penetrations
			instance.ricochet = ricochet
			instance.explosion = bullet_explosion
			instance.explode_chance = max(explode_chance, Globals.explode_chance)
			instance.homing = homing
			muzzle_flash.visible = true
		position += (knockback * (holder.global_position - global_position).normalized())
		flash_timer = 1
		shots_left -= 1
		if shots_left <= 0:
			reload()
		var inst = shell.instantiate()
		get_tree().current_scene.add_child(inst)
		inst.global_position = global_position
		inst.max_y = global_position.y+5
		sprite.scale = Vector2(1.3, 1.3)
		#Globals.camera.screenshake(shot_count * b.damage * 0.75)
		if !gunshot_sfx.is_playing():
			gunshot_sfx.pitch_scale = randf_range(0.9, 1.1)
			gunshot_sfx.play()
		elif gunshot_sfx.get_playback_position() > 0.05:
			gunshot_sfx.pitch_scale = randf_range(0.9, 1.1)
			gunshot_sfx.play()
		muzzle_flash.texture = muzzleflash_textures[randi_range(0, muzzleflash_textures.size()-1)]


func _on_reload_timer_timeout():
	shots_left = rounds


func set_game_over():
	game_over = true
	$Timer.stop()


func show_name():
	#gun_name_instance = gun_name.instantiate()
	get_tree().current_scene.add_child(gun_name_instance)
	var yoffset: int = 30 * sign(Globals.player.global_position.y - global_position.y)
	gun_name_instance.global_position = global_position + Vector2(0, -yoffset)
	gun_name_instance.get_node("RichTextLabel").text = "[center]Grab " + get_meta("Title") + "?"


func reset_material():
	if gun_name_instance != null:
		gun_name_instance.queue_free()


func _on_setup_timeout():
	setup_gun()


func setup_gun():
	shots_left = rounds
	firepoint = $GunFrame/Barrel/Firepoint
	muzzle_flash = $GunFrame/Barrel/Firepoint/MuzzleFlash


func attach_to_target(target: Node2D):
	follow_mouse = true
	can_press = false
	target.gun_pickup.emit()
	target.guns.append(self)
	holder = target
	$Timer.start()
	Globals.world_controller.add_to_gun_list(get_meta("Title"))
	get_parent().remove_child(self)
	Globals.player.get_node("Guns").add_child(self)
	Globals.ui.set_gun_amount()

 
func spin_gun():
	await get_tree().create_timer($ReloadTimer.wait_time-0.75).timeout
	Globals.audio_manager.reload.play()
	var reload_tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	reload_tween.set_ease(Tween.EASE_IN_OUT)
	reload_tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	reload_tween.tween_property(self, "rotation_degrees", rotation_degrees+360, 0.75)


func _on_mouse_entered():
	is_mouse_entered = true
	#if get_tree().paused:
		#Globals.activate_gunstats(self)


func _on_mouse_exited():
	is_mouse_entered = false
	#if get_tree().paused:
		#Globals.deactivate_gunstats()
