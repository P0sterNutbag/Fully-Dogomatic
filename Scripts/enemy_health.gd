extends Area2D
class_name HealthComponent

@export var health = 3
@export var rotate_on_hit: bool = true
@export var shake_on_hit: bool
@export var explosion_scale: float = 1
@export var sprite: Node2D
@export var healthbar: ProgressBar
@export var death_explosion = preload("res://Scenes/Particles/death_explosion.tscn")
var shake_timer: float = 0.0
var sprite_origin: Vector2
var flash_material = preload("res://Art/Shaders/flash.tres")
var dead: bool = false
var max_health
var bullet_dir
var parent


func _ready():
	sprite_origin = sprite.position
	parent = get_parent()


func _enter_tree() -> void:
	max_health = health
	dead = false


func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta
		if shake_timer <= 0:
			sprite.position = sprite_origin


func take_damage(dmg: float, bullet_direction: float):
	health -= dmg
	bullet_dir = bullet_direction
	if parent.has_method("on_damage"):
		parent.on_damage()
	sprite_flash()
	if rotate_on_hit:
		if global_position.x < Globals.player.global_position.x: 
			sprite.rotate(-2)
		else:
			sprite.rotate(2)
	if shake_on_hit:
		sprite.position = sprite_origin + Vector2(randi_range(-1, 1), randi_range(-1, 1))
		shake_timer = 0.05
	if healthbar != null:
		healthbar.visible = true
		healthbar.value = health / max_health
	if health <= 0 and not dead:
		dead = true
		#var pos = death_explosion.global_position
		#death_explosion.show()
		#death_explosion.play("default")
		#parent.remove_child(death_explosion)
		#get_tree().current_scene.add_child(death_explosion)
		#death_explosion.global_position = pos
		#if death_explosion != null:
			#var d = Globals.create_instance(death_explosion, global_position)
			#d.set_deferred("scale", Vector2.ONE * explosion_scale)
		var inst = death_explosion.instantiate()
		inst.global_position = global_position
		get_tree().current_scene.add_child.call_deferred(inst)
		Globals.audio_manager.explosion.play()
		if parent is Enemy:
			parent.on_death(bullet_direction)
			#parent.queue_free.call_deferred()
			# remove from tree
			#get_parent().get_parent().call_deferred("remove_child", get_parent())
		else:
			get_parent().queue_free()
		#Globals.world_controller.increase_score()
		#if !get_parent().name.contains("Boss"):
		#parent.call_deferred("queue_free")
	else:
		Globals.audio_manager.play_with_pitch(Globals.audio_manager.bullet_impact, 0.1)


func sprite_flash() -> void:
	if get_tree() == null:
		return
	sprite.use_parent_material = false
	sprite.material = flash_material
	await get_tree().create_timer(0.05).timeout
	sprite.material = null
	sprite.use_parent_material = true
