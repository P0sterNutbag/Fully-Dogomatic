extends Enemy

var distance_to_rush = 250
var rush_speed = 80
var rush_dir = Vector2.ZERO
var boss_name = "Max, prince of lumps"
var cutscene = preload("res://Scenes/Cutscenes/boss_death_cutscene.tscn")


func _ready():
	super._ready()
	Globals.ui.set_boss_hp(boss_name, 1)


func _process(delta):
	super._process(delta)


func _physics_process(delta):
	super._physics_process(delta)
	match state:
		states.attack:
			var dis = position.distance_to(target.global_position)
			if $RunCooldown.time_left <= 0 and dis <= distance_to_rush:
				state = states.rush
				rush_dir = (player.position - position).normalized()
				$RunTimer.start()
			$AnimatedSprite2D.speed_scale = 1
		states.rush:
			rush_dir = lerp(rush_dir, (player.position - position).normalized(), 2 * delta)
			velocity = rush_dir * rush_speed
			move_and_slide()
			$AnimatedSprite2D.speed_scale = 2


func _on_run_timer_timeout():
	state = states.attack
	$RunCooldown.start()


func on_damage():
	super.on_damage()
	Globals.ui.set_boss_hp(boss_name, $Hurtbox.health / $Hurtbox.max_health)


func on_death():
	Globals.enemy_spawn_controller.process_mode = PROCESS_MODE_DISABLED
	Globals.create_instance(cutscene)
	super.on_death()
