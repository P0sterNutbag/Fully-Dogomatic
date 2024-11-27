extends CharacterBody2D
class_name Enemy

enum states {spawn, attack, rush}
var state = states.spawn

@export var speed = 10.0
@export var damage = 0.05
@export var turn_speed = 5.0
var player: CharacterBody2D #= preload("res://player.gd")
var target: Node2D
var dollar = preload("res://Scenes/Player/dollar.tscn")
var blood = preload("res://Scenes/Particles/blood.tscn")
var dogpart = preload("res://Scenes/Particles/dogpart.tscn")
var money_min = 1
var money_max = 1
var fall_y = -200
var fall_x = 0
var time = 0
var game_over = false
var spawn_velocity: Vector2
var spawn_floor_y: float
var gravity: float = 900
var bullet_dir: float
var pipe_spawn: bool = false
@onready var sprite = $AnimatedSprite2D
@onready var health_component = $Hurtbox


func _ready():
	player = Globals.player
	if player != null:
		target = player;
	fall_x = randi_range(-100, 100)
	spawn_velocity = Vector2(randf_range(-50, 50), randf_range(-200, -300))
	$CollisionShape2D.disabled = true


func _physics_process(delta):
	if player == null:
		return
	match state:
		states.spawn:
			velocity = spawn_velocity
			spawn_velocity.y += gravity * delta
			if !pipe_spawn or (spawn_velocity.y > 0 and global_position.y > spawn_floor_y):
				$Hitbox.process_mode = Node.PROCESS_MODE_INHERIT
				$CollisionShape2D.disabled = false
				velocity = (player.position - position).normalized() * speed
				state = states.attack
				y_sort_enabled = true
				z_index = 0
			move_and_slide()
		states.attack:
			if target != null:
				time += 1
				if !game_over:
					var dir = (target.global_position - global_position).normalized()
					velocity = lerp(velocity, dir * speed, turn_speed * delta)
				else:
					velocity = Vector2(fall_x, fall_y)
					fall_y += 10
					if position.x > 900:
						queue_free()
				move_and_slide()
			else:
				if Globals.player != null:
					target = Globals.player
	if sprite.rotation_degrees != 0:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, float(0), 5 * delta)


func on_damage():
	pass


func on_death(bullet_direction: float = 0):
	if randf_range(0, 1) <= Globals.player.money_drop_rate:
		for i in randi_range(money_min, money_max):
			var d = Globals.create_instance(dollar, global_position)
			d.direction = bullet_direction + deg_to_rad(randf_range(-25, 25))
	Globals.create_instance(blood, $Shadow.global_position)
	Globals.world_controller.total_kills += 1
	#Globals.enemy_spawn_controller.enemies.erase(self)
	Globals.world_controller.level_controller.enemies.erase(self)


func _process(_delta):
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
