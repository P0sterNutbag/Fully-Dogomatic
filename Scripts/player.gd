extends CharacterBody2D
class_name Player

enum states {walk, bounce, dead, nap}
enum abilities {none, sprint, nap, free_reroll, sprint_on_hurt, hp, upgrade_cap}
var state = states.walk

@export var ability: abilities
@export var money: float = 0:
	set(value):
		money = value
		Globals.ui.set_money(value)
var base_speed = 75.0
var sprint_speed = 125.0
var speed = base_speed
var max_hp = 40
var money_cap: float = 4
var guns: Array[Node2D]
var dogtags: Array[Control]
var gun_slots: int = 10
var level: int = 1
var upgrade_cap_boost: int = 0
var time: float = 0
var gun_rotation: float = 0
var money_drop_bonus = 0
var shop_discount = 0
var explode_chance: float = 0
var time_to_sprint: float = 1.5
var sprint_timer: float = 0
var in_enemy: bool
var sawblade_protection: bool
var is_speed_debuffed: bool
var direction_x
var direction_y
var hp = 40:
	set(value):
		hp = value
		Globals.ui.get_node("LeftCorner/HPBar/HealthBar").value = hp
var gun_cap = 10:
	set(value):
		gun_cap = value
		Globals.ui.set_gun_amount(guns.size(), gun_cap)
var pickup_radius: float = 48:
	set(value):
		pickup_radius = value
		$MoneyPickup/CollisionShape2D.shape.radius = pickup_radius
var mine_time: float = 6:
	set(value):
		mine_time = value
		$MineTimer.wait_time = mine_time
		$MineTimer.start()
var mine = preload("res://Scenes/Bullets/mine.tscn")
@onready var sprite = $PlayerSprite
signal player_died
signal money_pickup


func _ready():
	Globals.player = self
	player_died.connect(Globals.ui.on_player_died)
	pickup_radius = $MoneyPickup/CollisionShape2D.shape.radius
	var hpbar = Globals.ui.get_node("LeftCorner/HPBar/HealthBar")
	hpbar.max_value = hp
	hpbar.value = hp
	if ability == abilities.hp:
		max_hp += 25
		hp += 25
		hpbar.size.x += 10
		hpbar.max_value = hp
		hpbar.value = hp
	if ability == abilities.upgrade_cap:
		upgrade_cap_boost = 1


func _enter_tree() -> void:
	Globals.ui.set_gun_amount(guns.size(), gun_cap)
	#Globals.ui.set_money(money)


func _physics_process(delta):
	direction_x = Input.get_axis("left", "right")
	direction_y = Input.get_axis("up", "down")
	match state:
		states.walk:
			# keyboard movement
			if direction_x:
				velocity.x = direction_x
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
			if direction_y:
				velocity.y = direction_y
			else:
				velocity.y = move_toward(velocity.y, 0, speed)
			velocity = velocity.normalized() * speed
			
			# mouse movement
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				if global_position.distance_to(get_global_mouse_position()) > 4:
					var move_vector = (get_global_mouse_position() - global_position).normalized()
					velocity = move_vector * speed
					direction_x = sign(velocity.x)
					direction_y = sign(velocity.y)
			
			# abilities
			if ability == abilities.sprint:
				if abs(rad_to_deg(get_last_motion().normalized().angle()) - rad_to_deg(velocity.normalized().angle())) < 1:
					sprint_timer += delta
				else:
					sprint_timer = 0
				var speed_mod = 1
				if is_speed_debuffed:
					speed_mod = 0.65
				if sprint_timer >= time_to_sprint:
					speed = sprint_speed * speed_mod
					sprite.speed_scale = 1.25
				else:
					speed = base_speed * speed_mod
					sprite.speed_scale = 1
			
			move_and_slide()
			
		states.bounce:
			velocity = lerp(velocity, Vector2.ZERO, 10 * delta)
			if abs(velocity) < Vector2.ONE*10:
				state = states.walk
			move_and_slide()
		
		states.nap:
			if direction_x or direction_y or Input.is_action_just_pressed("mouse_click"):
				for gun in guns:
					gun.process_mode = Node.PROCESS_MODE_ALWAYS
					gun.muzzle_flash.hide()
				state = states.walk
	
	# stay in bounds
	global_position.x = clamp(global_position.x, Globals.world_controller.barrier_left.global_position.x + 8, Globals.world_controller.barrier_right.global_position.x- 8)
	global_position.y = clamp(global_position.y, Globals.world_controller.barrier_left.global_position.y + 8, Globals.world_controller.barrier_right.global_position.y - 8)


func _process(delta):
	time += delta
	match state:
		states.walk:
			# animation
			if velocity.x != 0 or velocity.y != 0:
				sprite.play("walk")
				if velocity.x > 0:
					sprite.scale.x = 1
				elif velocity.x < 0:
					sprite.scale.x = -1
			else:
				sprite.play("idle")
			sprite.rotation_degrees = 0
			
			# damage
			for area in $Hurtbox.get_overlapping_areas():
				if area.is_in_group("enemy"):
					var enemy = area.get_owner()
					if !enemy.game_over:
						take_damage(enemy.damage * delta)
			
			# rotate guns
			$Guns.rotation_degrees += gun_rotation * delta
			
			# bark
			if Input.is_action_just_pressed("bark"):
				Globals.audio_manager.bark.pitch_scale = randf_range(0.95,1.05)
				Globals.audio_manager.bark.play()
			
			# abilities
			if ability == abilities.nap:
				if (!direction_x or !direction_y or !Input.is_action_pressed("mouse_click")) and hp < max_hp:
					if $NapTimer.is_stopped():
						$NapTimer.start()
				elif !$NapTimer.is_stopped():
					$NapTimer.stop()
		
		states.dead:
			sprite.play("dead")
			sprite.flip_h = false
			sprite.rotation_degrees = 0
		
		states.bounce:
			sprite.play("bounce")
			sprite.rotate(20 * delta)
		
		states.nap:
			sprite.play("nap")
			hp += delta * 1.25


func take_damage(dmg):
	if state == states.dead:
		return
	hp -= dmg
	Globals.world_controller.reset_score()
	if hp <= 0:
		state = states.dead
		player_died.emit()
		Globals.world_controller.level_controller.get_node("EnemySpawnTimer").stop()
	elif $FlashTimer.time_left <= 0:
		flash()
		in_enemy = true
	if ability == abilities.sprint_on_hurt:
		speed = sprint_speed
		await get_tree().create_timer(2).timeout
		speed = base_speed


func flash():
	$PlayerSprite.use_parent_material = false
	$FlashTimer.start()


func increase_health(hp2):
	hp = clamp(hp + hp2, 0, max_hp)


func get_money(amount: int):
	money_pickup.emit()
	money += amount
	#Globals.ui.set_money(money)
	if !Globals.audio_manager.chaching.is_playing():
			Globals.audio_manager.chaching.play()
	elif Globals.audio_manager.chaching.get_playback_position() > 0.25:
		Globals.audio_manager.chaching.play()
	if money >= 100:
		Globals.set_achievement("100_dollars")


func spend_money(amount: int):
	money -= amount
	money_pickup.emit()
	#Globals.ui.set_money(money)


func add_new_gun(gun: Gun):
	guns.append(gun)
	var gun_amount = guns.size()
	gun.get_parent().remove_child(gun)
	$Guns.add_child(gun)
	Globals.ui.set_gun_amount(gun_amount, gun_cap)
	if guns.size() == 15:
		Globals.set_achievement("gun_nut")


func sort_gun_array() -> void:
	guns.sort_custom(func(a, b): return global_position.angle_to_point(a.global_position) > global_position.angle_to_point(b.global_position))


func _on_money_pickup_area_entered(area):
	if area.is_in_group("money"):
		area.follow_player = true


func _on_drop_crate_timeout():
	$CrateSpawner.spawn_crate()


func _on_flash_timer_timeout():
	if !in_enemy:
		$FlashTimer.stop()
		$PlayerSprite.use_parent_material = true
		return
	$PlayerSprite.use_parent_material = !$PlayerSprite.use_parent_material


func _on_hurtbox_area_exited(_area):
	in_enemy = false
	#$FlashTimer.stop()
	#$PlayerSprite.use_parent_material = true


func _on_mine_timer_timeout() -> void:
	if state == states.dead:
		return
	Globals.create_instance(mine, global_position)


func _exit_tree() -> void:
	Globals.player = null


func _on_nap_timer_timeout() -> void:
	state = states.nap
	for gun in guns:
		gun.process_mode = Node.PROCESS_MODE_DISABLED
