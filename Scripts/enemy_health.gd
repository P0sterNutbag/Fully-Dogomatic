extends Area2D

@export var health = 3
@export var rotate_on_hit: bool = true
@export var death_explosion: PackedScene = preload("res://Scenes/death_explosion.tscn")
@export var sprite: Node2D
@export var healthbar: ProgressBar
var flash_material = preload("res://Shaders/flash.tres")
var dead: bool = false
var max_health
var bullet_dir


func _ready():
	max_health = health


func take_damage(dmg: float, bullet_direction: float):
	health -= dmg
	bullet_dir = bullet_direction
	var parent = get_parent()
	if parent.has_method("on_damage"):
		parent.on_damage()
	sprite_flash()
	if rotate_on_hit:
		if global_position.x < Globals.player.global_position.x: 
			sprite.rotate(-2)
		else:
			sprite.rotate(2)
	if healthbar != null:
		healthbar.visible = true
		healthbar.value = health / max_health
	if health <= 0 and not dead:
		dead = true
		if death_explosion != null:
			Globals.call_deferred("create_instance", death_explosion, global_position)
		if parent is Enemy:
			parent.on_death()
		Globals.explosion_sfx.play()
		#Globals.world_controller.increase_score()
		if !get_parent().name.contains("Boss"):
			parent.call_deferred("queue_free")


func sprite_flash() -> void:
	sprite.use_parent_material = false
	sprite.material = flash_material
	await get_tree().create_timer(0.05).timeout
	sprite.material = null
	sprite.use_parent_material = true
