extends Area2D

@export var gun: PackedScene = preload("res://Scenes/Guns/pistol.tscn")
@export var explosion: PackedScene = preload("res://Scenes/death_explosion.tscn")
var target_y: float
var falling = true
var fall_speed = 75
var has_spawned_gun = false
var upgrade: PackedScene
var break_particle = preload("res://Scenes/Particles/wood_particles.tscn")
var dead = false


func _physics_process(delta):
	if falling:
		if position.y <= target_y:
			position.y += fall_speed * delta
		else:
			$FallingSprite.visible = false
			$CrateSprite.visible = true 
			$Shadow.visible = true
			if falling:
				Globals.player.crate_position = global_position
			falling = false


func _on_area_entered(area):
	if !falling and area.is_in_group("bullet") and !dead:
		#Globals.crate_spawner.reset_timer()
		dead = true
		call_deferred("create_gun")
		call_deferred("create_explosion", area.move_vector.normalized())
		area.penetrations -= 1
		if area.penetrations <= 0:
			area.queue_free()
		queue_free()


func create_gun():
	if not has_spawned_gun:
		has_spawned_gun = true
		var instance = gun.instantiate()
		get_tree().current_scene.add_child(instance)
		instance.global_position = global_position
		if upgrade != null:
			instance.upgrade = upgrade
			instance.set_title()


func create_explosion(direction):
	var particle = break_particle.instantiate()
	get_tree().get_root().add_child(particle)
	particle.global_position = global_position
	particle.process_material.direction = Vector3(direction.x, direction.y, 0)
