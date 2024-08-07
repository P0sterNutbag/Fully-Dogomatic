extends CharacterBody2D

enum states {walk, dead}
var state = states.walk
var speed = 75.0
signal player_died
signal level_up(lvl: int)
signal money_pickup
signal gun_pickup(gun: Node2D)

var hp = 100
var max_hp = hp
var in_enemy = false
var enemies = []
var point_at_crate = false
var crate_position: Vector2
var money: float = 0
var money_cap: float = 4
var money_increase_rate = 1.4
var guns: Array[Node2D]
var gun_cap := 20
var dogtags: Array[Control]
var gun_slots: int = 10
var level: int = 1
var time: float = 0
var target_zoom = 1
var gun_rotation: float = 0
@onready var sprite = $PlayerSprite


func _ready():
	Globals.player = self


func _physics_process(_delta):
	match state:
		states.walk:
			# keyboard movement
			var direction_x = Input.get_axis("left", "right")
			var direction_y = Input.get_axis("up", "down")
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
				var move_vector = (get_global_mouse_position() - global_position).normalized()
				velocity = move_vector * speed
			
			move_and_slide()
			
			# stay in bounds
			position.x = clamp(position.x, -485, 485)
			position.y = clamp(position.y, -485, 485)
		


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
				Globals.audio_manager.bark.pitch_scale = randf_range(0.95,1.05)
				Globals.audio_manager.bark.play()
		
		states.dead:
			sprite.play("dead")
			sprite.flip_h = false


func take_damage(dmg):
	hp -= dmg
	Globals.ui.get_node("LeftCorner/HPBar/HealthBar").value = hp
	Globals.world_controller.reset_score()
	if hp <= 0:
		state = states.dead
		player_died.emit()
	elif $FlashTimer.time_left <= 0:
		$FlashTimer.start()


func increase_health(hp2):
	hp = clamp(hp + hp2, 0, max_hp)
	Globals.ui.get_node("LeftCorner/HPBar/HealthBar").value = hp


func get_money(amount: int):
	money_pickup.emit()
	money += amount
	Globals.ui.set_money(money)
	Globals.world_controller.set_money(money / money_cap)
	if !Globals.audio_manager.chaching.is_playing():
			Globals.audio_manager.chaching.play()
	elif Globals.audio_manager.chaching.get_playback_position() > 0.25:
		Globals.audio_manager.chaching.play()


func spend_money(amount: int):
	money -= amount
	money_pickup.emit()
	Globals.ui.set_money(money)


func _on_money_pickup_area_entered(area):
	if area.is_in_group("money"):
		area.follow_player = true


func _on_drop_crate_timeout():
	$CrateSpawner.spawn_crate()


func zoom_out_camera():
	target_zoom = 0.75
	await get_tree().create_timer(3).timeout
	target_zoom = 1



func _on_flash_timer_timeout():
	$PlayerSprite.use_parent_material = !$PlayerSprite.use_parent_material


func _on_hurtbox_area_exited(area):
	$FlashTimer.stop()
	$PlayerSprite.use_parent_material = true
