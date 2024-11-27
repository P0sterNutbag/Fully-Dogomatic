extends Enemy
class_name Boss

@export var boss_name = "Max, prince of lumps"
var cutscene = preload("res://Scenes/Cutscenes/boss_death_cutscene.tscn")


func _ready():
	super._ready()
	Globals.ui.set_boss_hp(boss_name, 1)
	state = states.attack


func _physics_process(delta):
	if !Globals.player:
		return
	match state:
		states.attack:
			attack(delta)
		states.rush:
			rush(delta)

func attack(delta) -> void:
	pass


func rush(delta) -> void:
	pass


func on_damage():
	super.on_damage()
	Globals.ui.set_boss_hp(boss_name, $Hurtbox.health / $Hurtbox.max_health)


func on_death(bullet_direction: float = 0):
	#Globals.enemy_spawn_controller.process_mode = PROCESS_MODE_DISABLED
	Globals.create_instance(cutscene)
	#super.on_death()
