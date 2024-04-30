extends Control

@export var gun_upgrade: bool
@export var player_upgrade: bool
@export var variable_name: String
@export var value: float
var target_position: Vector2
var scene: Node


func _ready():
	$JuicyMovement.set_process(false)
	if player_upgrade: 
		scene = Globals.player
	else:
		scene = Globals.globals


func _process(delta):
	if target_position != Vector2(0, 0):
		global_position = lerp(global_position, target_position, delta * 5)
		scale = lerp(scale, Vector2(1, 1), delta * 5)
		$JuicyMovement.set_process(true)


func apply_upgrade():
	print_debug("variable is " + variable_name)
	print_debug("value is " + str(value))
	var new_value = scene.get(variable_name) + value
	scene.set(variable_name, new_value)

