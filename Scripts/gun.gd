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
@export var equal_spread: bool = false
@export var rounds: int = 20  
@export var bullet_speed: int = 1200
@export var reload_time: float = 2: 
	set(value): 
		reload_time = value
		$ReloadTimer.wait_time = reload_time
@export var penetrations: int = 1
@export var knockback: int = 7.5
@export var explode_chance: float = 0
@export var ricochet: bool
@export var bullet_explosion: PackedScene
@export_subgroup("Sounds")
@export var sound_shoot: String  # Sound path
var bullet_scale = Vector2.ONE
var bullet_can_warp: bool
var burst_fire: bool
var bullet_range: float = 0
var burst_shots_left: int = 3
var distance_to_player = 18
var damage_boost: float = 1
var homing: bool = false
var holder = null
var hold_offset: Vector2
var direction_vector: Vector2
var shots_left: int
var flash_timer := 0
var x_force = 0
var upgrades = 0
var max_upgrades = 3
var follow_mouse = false
var locked: bool = false
var knockback_force: float = 0
var is_mouse_entered: bool = false
var aim_dir := Vector2.RIGHT
var can_delete: bool = false
var roulette: bool:
	set (value):
		roulette = value
		roulette_index = get_roulette_index()
var roulette_index: int
var roulette_bonus: int = 0
var can_press: bool
var gunshot_sfx: AudioStreamPlayer2D
var loadout_text: Control
var original_aim_dir: Vector2
var has_aim_assist: bool:
	set (value):
		has_aim_assist = value
		if has_aim_assist:
			aim_assist.process_mode = PROCESS_MODE_INHERIT
		else:
			aim_assist.process_mode =  PROCESS_MODE_DISABLED
var shell = preload("res://Scenes/Particles/shell.tscn")
var status_effect = preload("res://Scenes/Particles/gun_status.tscn")
var muzzleflash_textures = [preload("res://Art/Sprites/muzzleflash.png"), 
preload("res://Art/Sprites/muzzleflash2.png"),
preload("res://Art/Sprites/muzzleflash3.png")]
@onready var sprite = $Sprite2D
@onready var firepoint = $Firepoint
@onready var muzzle_flash = $Firepoint/MuzzleFlash
@onready var aim_assist = $AimAssist
signal gun_deleted


func _ready() -> void:
	distance_to_player += $CollisionShape2D.shape.size.x / 2
	x_force = randf_range(-100,100)


func _enter_tree() -> void:
	gunshot_sfx = Globals.audio_manager.get(sound_shoot)
	shots_left = rounds
	$ReloadTimer.wait_time = reload_time


func _physics_process(delta):
	if follow_mouse:
		if abs(Input.get_last_mouse_velocity()) > Vector2.ZERO:
			aim_dir = (get_global_mouse_position() - get_parent().global_position).normalized()
		#if abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_X)) > InputController.axis_threshold or abs(Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)) > InputController.axis_threshold:
			#aim_dir = Vector2(Input.get_joy_axis(0, JOY_AXIS_LEFT_X), Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)).normalized()
		elif abs(Input.get_axis("left", "right")) > InputController.axis_threshold:
			aim_dir = aim_dir.rotated(Input.get_axis("left", "right") * 2 * delta)
		elif abs(Input.get_axis("up", "down")) > InputController.axis_threshold:
			aim_dir = aim_dir.rotated(Input.get_axis("up", "down") * 2 * delta)
		global_position = lerp(global_position, Globals.player.global_position + aim_dir * distance_to_player * 1.5, delta * 10)
		global_rotation = aim_dir.angle()
		if global_position.x < holder.global_position.x:
			scale.y = -1
		else:
			scale.y = 1
		if Input.is_action_just_pressed("back"):
			Globals.upgrade_menu.refund()
			gun_deleted.emit()
			Globals.player.guns.erase(self)
			Globals.ui.set_gun_amount(Globals.player.guns.size(), Globals.player.gun_cap)
			queue_free()
	else:
		if holder != null:
			rotation = lerp_angle(rotation, aim_dir.angle(), 10 * delta)
			#position = lerp(position, aim_dir * distance_to_player, delta * 10)
	if sprite.scale != Vector2(1,1):
		sprite.scale = sprite.scale.lerp(Vector2(1, 1), 6 * delta)


func _process(_delta):
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
			original_aim_dir = aim_dir
			#has_aim_assist = true
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
	$ShootTimer.stop()
	Globals.create_instance(status_effect, global_position + Vector2(0, -8))
	await get_tree().create_timer($ReloadTimer.wait_time-1).timeout
	spin_gun()
	if roulette:
		roulette_index = get_roulette_index()


func _on_timer_timeout(): # shoot bullets
	if get_tree().paused: return
	if Globals.player == null: return
	if shots_left > 0:
		if holder.state == holder.states.dead:
			return
		# determine accuracy
		var accuracy_mod = -10
		if abs(Globals.player.velocity) > Vector2.ZERO:
			accuracy_mod = 0
		# shoot bullets
		for i in bullet_count:
			var instance = bullet.instantiate()
			instance.global_position = firepoint.global_position
			var accuracy = clamp(spread + accuracy_mod, 0, 100)
			var bullet_angle
			if !equal_spread:
				bullet_angle = aim_dir.angle() + deg_to_rad(randf_range(-accuracy, accuracy))
			else:
				bullet_angle = aim_dir.angle() + deg_to_rad(((i + 1) * (accuracy / bullet_count)) - (accuracy / 2))
			var bullet_vector = Vector2.RIGHT.rotated(bullet_angle) * bullet_speed
			instance.move_vector = bullet_vector
			instance.speed = bullet_speed
			instance.global_rotation = bullet_angle
			instance.damage  = bullet_damage * damage_boost
			instance.damage_boost = damage_boost
			instance.scale = bullet_scale
			instance.penetrations = penetrations
			instance.ricochet = ricochet
			instance.explode_chance = max(explode_chance, Globals.player.explode_chance)
			instance.homing = homing
			instance.can_warp = bullet_can_warp
			instance.range = bullet_range
			if bullet_explosion:
				instance.explosion = bullet_explosion
			rotation = bullet_angle
			instance.knockback_force = knockback_force
			get_tree().current_scene.add_child(instance)
			if roulette: 
				if roulette_index == shots_left:
					instance.damage = round(bullet_damage * rounds * roulette_bonus)
				else:
					instance.queue_free()
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
		# burst fire
		if burst_fire:
			if shots_left > 0:
				if burst_shots_left > 1:
					burst_shots_left -= 1
					$ShootTimer.wait_time = cooldown * 0.25
					$ShootTimer.start()
				else:
					burst_shots_left = 3
					$ShootTimer.wait_time = cooldown * 1.5
					$ShootTimer.start()
			else:
				burst_shots_left = 3


func get_roulette_index() -> int:
	return randi_range(rounds, 1)


func _on_reload_timer_timeout():
	shots_left = rounds
	_on_timer_timeout()
	$ShootTimer.start()


func attach_to_target(target: Node2D):
	follow_mouse = true
	can_press = false
	target.add_new_gun(self)
	holder = target


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
