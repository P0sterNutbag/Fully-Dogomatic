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
var locked: bool = false
var is_mouse_entered: bool = false
var aim_dir: Vector2
var muzzleflash_textures = [preload("res://Sprites/muzzleflash.png"), 
preload("res://Sprites/muzzleflash2.png"),
preload("res://Sprites/muzzleflash3.png")]

@onready var sprite = $GunFrame
var firepoint
var muzzle_flash
var firepoint_index = 0
var shell = preload("res://Scenes/shell.tscn")
var gun_name = preload("res://Scenes/Guns/gun_name.tscn")
var status_effect = preload("res://Scenes/Particles/gun_status.tscn")
var gun_name_instance: Node2D
var bullet_damage


func _ready():
	x_force = randf_range(-100,100)


func _physics_process(delta):
	if follow_mouse:
		#var dir_offset = Vector2.RIGHT.rotated(get_parent().rotation)
		aim_dir = (get_global_mouse_position() - get_parent().global_position).normalized()
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
	if Input.is_action_just_pressed("select"):
		if get_tree().paused and !Globals.holding_gun_part and !Globals.settings_open and !locked:
			#if not follow_mouse:
				#pass
				#if is_mouse_entered:
					#follow_mouse = true
					#if not holder:
						#attach_to_target(Globals.player)
			#else:
			follow_mouse = false


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
		var b = bullet.instantiate()
		shot_count = b.shot_count
		var accuracy_mod = -5
		if abs(Globals.player.velocity) > Vector2.ZERO:
			accuracy_mod = 3 #max(abs(Globals.player.velocity.x), abs(Globals.player.velocity.y)) / 10
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
			instance.damage  = bullet_damage#+= damage_modifier
			instance.penetrations += penetrations_modifier
			instance.ricochet = ricochet
			instance.explode_chance = Globals.explode_chance
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
		if !Globals.audio_manager.gunshot.is_playing():
			Globals.audio_manager.gunshot.play()
		elif Globals.audio_manager.gunshot.get_playback_position() > 0.05:
			Globals.audio_manager.gunshot.play()
		b.queue_free()
		muzzle_flash.texture = muzzleflash_textures[randi_range(0, muzzleflash_textures.size()-1)]


func _on_reload_timer_timeout():
	shots_left = rounds
	Globals.audio_manager.reload.play()


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


func _on_setup_timeout():
	setup_gun()


func setup_gun():
	shots_left = rounds
	firepoint = $GunFrame/Barrel/Firepoint
	muzzle_flash = $GunFrame/Barrel/Firepoint/MuzzleFlash


func attach_to_target(target: Node2D):
	target.gun_pickup.emit()
	target.guns.append(self)
	holder = target
	$Timer.start()
	Globals.world_controller.add_to_gun_list(get_meta("Title"))
	get_parent().remove_child(self)
	Globals.player.get_node("Guns").add_child(self)


func spin_gun():
	var reload_tween = get_tree().create_tween().set_trans(Tween.TRANS_ELASTIC)
	reload_tween.set_ease(Tween.EASE_IN_OUT)
	reload_tween.tween_property(self, "rotation_degrees", rotation_degrees, $ReloadTimer.wait_time-0.75)
	reload_tween.tween_property(self, "rotation_degrees", rotation_degrees+360, 0.75)


func _on_mouse_entered():
	is_mouse_entered = true
	if get_tree().paused:
		Globals.activate_gunstats(self)


func _on_mouse_exited():
	is_mouse_entered = false
	if get_tree().paused:
		Globals.deactivate_gunstats()
