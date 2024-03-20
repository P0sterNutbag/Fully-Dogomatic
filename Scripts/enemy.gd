extends CharacterBody2D

@export var speed = 10.0
@export var health = 3
@export var damage = 0.05
@export var drop_chance = 0.25
@export var death_explosion: PackedScene

var player: CharacterBody2D #= preload("res://player.gd")
var target: CharacterBody2D
var dollar = preload("res://Scenes/dollar.tscn")
var blood = preload("res://Scenes/blood.tscn")
var flash_material = preload("res://Shaders/flash.tres")
var dogpart = preload("res://Scenes/dogpart.tscn")
@export var money_min = 3
@export var money_max = 4
var fall_y = -200
var fall_x = 0
var time = 0
var game_over = false
var dead: bool = false

@onready var sprite = $AnimatedSprite2D


func _ready():
	player = Globals.player
	if player != null:
		target = player;
	fall_x = randi_range(-100, 100)


func take_damage(dmg: float):
	health -= dmg
	sprite_flash()
	if global_position.x < Globals.player.global_position.x: 
		sprite.rotate(-2)
	else:
		sprite.rotate(2)
	if health <= 0 and not dead:
		dead = true
		call_deferred("spawn", death_explosion)
		if randf_range(0, 1) <= drop_chance:
			for i in randi_range(money_min, money_max):
				call_deferred("spawn", dollar)
		call_deferred("spawn", blood)
		for i in randi_range(3,5):
			call_deferred("spawn", dogpart)
		Globals.explosion_sfx.play()
		Globals.world_controller.increase_score()
		call_deferred("queue_free")


func sprite_flash() -> void:
	sprite.material = flash_material
	await get_tree().create_timer(0.05).timeout
	sprite.material = null
	#var tween: Tween = create_tween()
	#tween.tween_property(sprite, "modulate:v", 1, 0.1).from(150)


func spawn(scene):
	var inst = scene.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.position = global_position
	if scene == dollar:
		inst.global_position += Vector2(randf_range(-10,10),randf_range(-10,10))
	if scene == dogpart:
		inst.max_y = global_position.y
		inst.speed = 500


func _physics_process(delta):
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


func _process(_delta):
	if velocity.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

