extends CharacterBody2D

enum states {walk, dead}
var state = states.walk
var speed = 50.0
signal player_died
signal level_up(lvl: int)
signal money_pickup
signal gun_pickup(gun: Node2D)

var max_hp = 100
var hp = 100
var in_enemy = false
var enemies = []
var point_at_crate = false
var crate_position: Vector2
var money: float = 0
var money_cap: float = 4
var money_increase_rate = 1.4
var guns: Array[Node2D]
var dogtags: Array[Control]
var gun_slots: int = 10
var level: int = 1
var time: float = 0
var new_gun_material = preload("res://Shaders/outline.tres")
var target_zoom = 1
var gun_rotation: float = 0
@onready var sprite = $PlayerSprite


func _ready():
	Globals.player = self
	Globals.shoot_sfx = $Gunshot
	Globals.reload_sfx = $Reload
	Globals.explosion_sfx = $Explosion
	$HealthBar.visible = false


func _physics_process(_delta):
	match state:
		states.walk:
			# keyboard movement
			var direction_x = Input.get_axis("left", "right")
			var direction_y = Input.get_axis("up", "down")
			if direction_x:
				velocity.x = direction_x * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)
			if direction_y:
				velocity.y = direction_y * speed
			else:
				velocity.y = move_toward(velocity.y, 0, speed)
			
			# mouse movement
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				var move_vector = (get_global_mouse_position() - global_position).normalized()
				velocity = move_vector * speed
			
			move_and_slide()
			
			# stay in bounds
			position.x = clamp(position.x, -790, 790)
			position.y = clamp(position.y, -790, 790)
		


func _process(delta):
	time += delta
	match state:
		states.walk:
			# animation
			if velocity.x != 0 or velocity.y != 0:
				sprite.play("walk")
				if velocity.x > 0:
					sprite.flip_h = false
				elif velocity.x < 0:
					sprite.flip_h = true
			else:
				sprite.play("idle")

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
				$Bark.pitch_scale = randf_range(0.95,1.05)
				$Bark.play()
		
		states.dead:
			sprite.play("dead")
			sprite.flip_h = false
	# zoom camera
	#$Camera2D.zoom  = $Camera2D.zoom.lerp(Vector2(target_zoom, target_zoom), 5 * delta)


func take_damage(dmg):
	hp -= dmg
	$HealthBar.visible = true
	$HealthBar.value = hp
	Globals.world_controller.reset_score()
	if hp <= 0:
		state = states.dead
		player_died.emit()
		$HealthBar.visible = false


func increase_health(hp2):
	hp = clamp(hp + hp2, 0, max_hp)
	$HealthBar.value = hp
	if hp >= max_hp:
		$HealthBar.visible = false


func get_money(amount: int):
	money_pickup.emit()
	money += amount
	Globals.ui.set_money(money)
	Globals.world_controller.set_money(money / money_cap)
	if !$Chaching.is_playing():
			$Chaching.play()
	elif $Chaching.get_playback_position() > 0.25:
		$Chaching.play()
	#if money >= money_cap:
		#level += 1
		#level_up.emit(level)
		#money = 0
		#money_cap *= money_increase_rate
		#Globals.world_controller.spawn_upgrade_menu()
		##Globals.crate_spawner.spawn_crate()
		#$Bark.play()


func spend_money(amount: int):
	money -= amount
	money_pickup.emit()
	Globals.ui.set_money(money)

#func _on_area_2d_area_entered(area):
	#if area.is_in_group("gun") and area.holder != self:
		#gun_pickup.emit()
		#guns.append(area)
		#area.holder = self
		#var dir_to_gun = (area.position - position).normalized()
		#area.direction_vector = dir_to_gun
		#area.rotation = dir_to_gun.angle()
		#area.hold_offset = dir_to_gun * area.distance_to_player
		#area.get_node("Timer").start()
		##if area.global_position.x < global_position.x:
			##area.sprite.flip_v = true
			##area.firepoint_index = 1
			##area.get_node("MuzzleOffset").position = area.firepoints[area.firepoint_index].position
		#Globals.world_controller.add_to_gun_list(area.get_meta("Title"))



func _on_money_pickup_area_entered(area):
	if area.is_in_group("money"):
		area.follow_player = true


func _on_gun_highliter_area_entered(_area):
	pass
	# if not guns.has(area):
	# 	area.show_name()
		#area.get_node("Sprite2D").material = new_gun_material


func _on_gun_highliter_area_exited(_area):
	pass
	# area.reset_material()


func _on_drop_crate_timeout():
	$CrateSpawner.spawn_crate()


func zoom_out_camera():
	target_zoom = 0.75
	await get_tree().create_timer(3).timeout
	target_zoom = 1


func _on_deffered_variables_timeout():
	pass
	#$Camera2D.limit_left = Globals.barrier_left.x
	#$Camera2D.limit_top = Globals.barrier_left.y
	#$Camera2D.limit_right = Globals.barrier_right.x
	#$Camera2D.limit_bottom = Globals.barrier_right.y
