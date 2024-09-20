extends Control

@export var upgrade_values: Array[VariableChange]
@export var player_upgrade: bool
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
	for variable_change in upgrade_values:
		if variable_change.add_value:
			scene.set(variable_change.values[0], scene.get(variable_change.values[0]) + variable_change.values[1])
		elif variable_change.multiply_value:
			scene.set(variable_change.values[0], scene.get(variable_change.values[0]) * variable_change.values[1])
		else:
			scene.set(variable_change.values[0], variable_change.values[1])
		if variable_change.values[0] == "max_hp":
			Globals.ui.hp_bar.size.x += variable_change.values[1] * 0.75
