extends CharacterBody2D
class_name Enemy

enum states {spawn, attack, rush}
var state = states.spawn

@export var speed = 10.0
@export var damage = 0.05
var player: CharacterBody2D #= preload("res://player.gd")
var target: CharacterBody2D
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
@onready var sprite = $AnimatedSprite2D
var bullet_dir: float
var pipe_spawn: bool = false


func _ready():
	player = Globals.player
	if player != null:
		target = player;
	fall_x = randi_range(-100, 100)
	spawn_velocity = Vector2(randf_range(-50, 50), randf_range(-200, -300))


func spawn(scene):
	var inst = Globals.create_instance(scene, global_position)
	if scene == dollar:
		inst.global_position += Vector2(randf_range(-10,10),randf_range(-10,10))
	if scene == dogpart:
		inst.max_y = global_position.y
		inst.speed = 500


func _physics_process(delta):
	match state:
		states.spawn:
			velocity = spawn_velocity
			spawn_velocity.y += gravity * delta
			if !pipe_spawn or (spawn_velocity.y > 0 and global_position.y > spawn_floor_y):
				$Hitbox.process_mode = Node.PROCESS_MODE_INHERIT
				state = states.attack
				y_sort_enabled = true
				z_index = 0
			move_and_slide()
		states.attack:
			if target != null:
				time += 1
				if !game_over:
					if fmod(time, 30) == 1:
						var dir = (player.position - position).normalized()
						velocity = dir * speed
				else:
					velocity = Vector2(fall_x, fall_y)
					fall_y += 10
					if position.x > 900:
						queue_free()
				move_and_slide()
	if sprite.rotation_degrees != 0:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, float(0), 5 * delta)


func on_damage():
	pass
	#for i in randi_range(1,2):
		#var inst = dogpart.instantiate()
		#get_tree().current_scene.add_child(inst)
		#inst.position = global_position
		#inst.set_speed($Hurtbox.bullet_dir)


func on_death():
	if randf_range(0, 1) <= Globals.money_drop_rate:
		for i in randi_range(money_min, money_max):
			call_deferred("spawn", dollar)
	Globals.create_instance(blood, $Shadow.global_position)
	Globals.world_controller.total_kills += 1


func _process(_delta):
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
