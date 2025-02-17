extends EnemyIncramental
class_name Boss

@export var boss_name = "Max, prince of lumps"
@export var aim_y_offset = 12
var cutscene = preload("res://Scenes/Cutscenes/boss_death_cutscene.tscn")
var win_screen_demo = preload("res://Scenes/Levels/win_screen_demo.tscn")
var is_demo: bool

func _ready():
	super._ready()
	state = states.attack
	Globals.ui.set_boss_hp(boss_name, 1)


func _physics_process(delta):
	if !Globals.player:
		return
	match state:
		states.attack:
			attack(delta)
			if velocity.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		states.rush:
			rush(delta)
			if velocity.x < 0:
				sprite.flip_h = true
			else:
				sprite.flip_h = false
		states.knockback:
			velocity = velocity.move_toward(Vector2.ZERO, delta * 500)
			if velocity <= Vector2.ZERO:
				state = states.attack
			move_and_slide()


func attack(delta) -> void:
	var dir = ((Globals.player.global_position + Vector2.DOWN * aim_y_offset) - global_position).normalized()
	velocity = lerp(velocity, dir * speed, turn_speed * delta)
	move_and_slide()


func rush(delta) -> void:
	pass


func on_damage():
	super.on_damage()
	Globals.ui.set_boss_hp(boss_name, $Hurtbox.health / $Hurtbox.max_health)


func on_death(bullet_direction: float = 0):
	if is_demo:
		var inst = win_screen_demo.instantiate()
		Globals.ui.add_child(inst)
		return
	Globals.world_controller.bosses_killed += 1
	for i in 15:
		var d = Globals.create_instance(dollar, global_position)
		d.direction = bullet_direction + deg_to_rad(randf_range(-25, 25))
	if Globals.world_controller.bosses_killed >= 3:
		Globals.set_achievement("bosses")
	super.on_death()
	##Globals.enemy_spawn_controller.process_mode = PROCESS_MODE_DISABLED
	#Globals.create_instance(cutscene)
	##super.on_death()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.get_parent() != self and area is HealthComponent and area.get_parent() is not Boss:
		area.take_damage(10000, 0)
