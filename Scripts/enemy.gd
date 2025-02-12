extends CharacterBody2D
class_name Enemy

enum states {spawn, attack, rush, knockback}
var state = states.attack

@export var speed = 10.0
@export var damage = 0.05
@export var turn_speed = 5.0
@export var money_amount: int
@export var queue_index: int
var player: CharacterBody2D #= preload("res://player.gd")
var target: Node2D
var dollar = preload("res://Scenes/Player/dollar.tscn")
var blood = preload("res://Scenes/Particles/blood.tscn")
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
	state = states.attack
	y_sort_enabled = true
	z_index = 0


func _physics_process(delta):
	if target == null:
		if Globals.player != null:
			target = Globals.player
		return
	match state:
		states.attack:
			time += delta
			if fmod(time, 0.25) < delta:
				var dir = (target.global_position - global_position).normalized()
				velocity = dir * speed#lerp(velocity, dir * speed, turn_speed * delta)
			move_and_slide()
			if velocity.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		states.knockback:
			velocity = velocity.move_toward(Vector2.ZERO, delta * 500)
			if velocity <= Vector2.ZERO:
				state = states.attack
			move_and_slide()
	if sprite.rotation_degrees != 0:
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, float(0), 5 * delta)


func on_damage():
	pass


func on_death(bullet_direction: float = 0):
	#if randf_range(0, 1) <= Globals.player.money_drop_rate:
	Globals.level_manager.current_kills += 1
	if Globals.level_manager.current_kills >= Globals.level_manager.kills_to_money:
		var money_amount = randi_range(1, 3)
		Globals.level_manager.reset_kills(money_amount)
		for i in money_amount:
			var d = Globals.create_instance(dollar, global_position)
			d.direction = bullet_direction + deg_to_rad(randf_range(-45, 45))
	Globals.create_instance(blood, $Shadow.global_position)
	Globals.world_controller.total_kills += 1
	Globals.world_controller.level_controller.enemies.erase(self)
	queue_free()


func knockback(vector: Vector2) -> void:
	state = states.knockback
	velocity = vector
	
