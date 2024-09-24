extends Area2D

class_name Gun


@export_subgroup("Properties")
@export var bullet: PackedScene = preload("res://Scenes/Bullets/regular_bullet.tscn")
@export var bullet_damage: float = 3
@export var bullet_count: float = 1
@export var cooldown: float = 1:
	set(value): 
		cooldown = value
		if cooldown > 0:
			$ShootTimer.wait_time = value
@export var spread: float = 20 
@export var rounds: int = 20  
@export var bullet_speed: int = 15
@export var reload_time: float = 2: 
	set(value): 
		reload_time = value
		$ReloadTimer.wait_time = reload_time
@export var penetrations: int = 1
@export var knockback: int = 5
@export var bullet_explosion: PackedScene = preload("res://Scenes/Bullets/bullet_explosion.tscn")
@export_subgroup("Sounds")
@export var sound_shoot: String  # Sound path
var distance_to_player = 18
var ricochet: bool = false
var homing: bool = false
var explode_chance: float = 0
var holder = null
var hold_offset: Vector2
var direction_vector: Vector2
var shots_left: int
var flash_timer := 0
var grav_force = -200
var x_force = 0
var upgrades = 0
var follow_mouse = false
var locked: bool = false
var is_mouse_entered: bool = false
var aim_dir := Vector2.RIGHT
var can_delete: bool = false
var can_press: bool
var gunshot_sfx: AudioStreamPlayer2D
var loadout_text: Control
var shell = preload("res://Scenes/Particles/shell.tscn")
var status_effect = preload("res://Scenes/Particles/gun_status.tscn")
var muzzleflash_textures = [preload("res://Art/Sprites/muzzleflash.png"), 
preload("res://Art/Sprites/muzzleflash2.png"),
preload("res://Art/Sprites/muzzleflash3.png")]
@onready var sprite = $Sprite2D
@onready var firepoint = $Firepoint
@onready var muzzle_flash = $Firepoint/MuzzleFlash
signal gun_deleted


func _ready():
	x_force = randf_range(-100,100)
	gunshot_sfx = Globals.audio_manager.get(sound_shoot)
	distance_to_player += $CollisionShape2D.shape.size.x / 2
	shots_left = rounds


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
	#else:
		#if holder != null:
			#position = lerp(position, aim_dir * distance_to_player, delta * 10)
	if sprite.scale != Vector2(1,1):
		sprite.scale = sprite.scale.lerp(Vector2(1, 1), 6 * delta)


func _process(delta):
	if Input.is_action_just_pressed("select") and can_press:
		if can_delete and is_mouse_entered:
			gun_deleted.emit()
			Globals.player.guns.erase(self)
			queue_free()
		if follow_mouse:
			follow_mouse = false
			$ShootTimer.start()
			process_mode = PROCESS_MODE_PAUSABLE
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
	var status_effect = Globals.create_instance(status_effect, global_position + Vector2(0, -8))
	await get_tree().create_timer($ReloadTimer.wait_time-0.75).timeout
	spin_gun()


func _on_timer_timeout(): # shoot bullets
	if get_tree().paused: return
	if Globals.player == null: return
	if shots_left > 0:
		if holder.state == holder.states.dead:
			return
		# determine accuracy
		var accuracy_mod = -5
		if abs(Globals.player.velocity) > Vector2.ZERO:
			accuracy_mod = 3
		# shoot bullets
		for i in bullet_count:
			var instance = bullet.instantiate()
			get_tree().current_scene.add_child(instance)
			instance.global_position = firepoint.global_position
			var accuracy = clamp(spread + accuracy_mod, 0, 100)
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
		# expend ammo
		shots_left -= 1
		if shots_left <= 0:
			reload()
		# effects
		position += (knockback * (holder.global_position - global_position).normalized())
		sprite.scale = Vector2(1.3, 1.3)
		muzzle_flash.texture = muzzleflash_textures[randi_range(0, muzzleflash_textures.size()-1)]
		muzzle_flash.visible = true
		$FlashTimer.start()
		var shell_inst = Globals.create_instance(shell, global_position)
		shell_inst.max_y = global_position.y+5
		# play sounds
		if !gunshot_sfx.is_playing():
			gunshot_sfx.pitch_scale = randf_range(0.9, 1.1)
			gunshot_sfx.play()
		elif gunshot_sfx.get_playback_position() > 0.05:
			gunshot_sfx.pitch_scale = randf_range(0.9, 1.1)
			gunshot_sfx.play()


func _on_reload_timer_timeout():
	shots_left = rounds


func attach_to_target(target: Node2D):
	follow_mouse = true
	can_press = false
	target.gun_pickup.emit()
	target.add_new_gun(self)
	holder = target
	Globals.world_controller.add_to_gun_list(get_meta("Title"))


func spin_gun():
	Globals.audio_manager.reload.play()
	var reload_tween = create_tween().set_trans(Tween.TRANS_ELASTIC)
	reload_tween.set_ease(Tween.EASE_IN_OUT)
	reload_tween.set_pause_mode(Tween.TWEEN_PAUSE_STOP)
	reload_tween.tween_property(self, "rotation_degrees", rotation_degrees+360, 0.75)


func _on_mouse_entered():
	is_mouse_entered = true


func _on_mouse_exited():
	is_mouse_entered = false


func _on_flash_timer_timeout() -> void:
	muzzle_flash.visible = false
