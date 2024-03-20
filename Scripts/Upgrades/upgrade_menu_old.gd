extends CanvasLayer

@export var options: Array[Node2D]
var current_upgrades: Array[PackedScene]
var current_option: int
var current_gun: int
var has_chosen_upgrade: bool = false
signal gun_selected(change_int: int)
signal upgrade_assigned


func _ready():
	get_tree().paused = true
	var ui_guns = Globals.world_controller.get_node("CanvasLayer/Guns")
	gun_selected.connect(ui_guns._on_gun_selected)
	upgrade_assigned.connect(ui_guns._on_upgrade_assigned)
	options[0].select()


func _process(delta):
	# selection option
	if Input.is_action_just_pressed("right") and not has_chosen_upgrade:
		options[current_option].unselect()
		current_option += 1
		if current_option > options.size()-1:
			current_option = 0
		options[current_option].select()
	if Input.is_action_just_pressed("left") and not has_chosen_upgrade:
		options[current_option].unselect()
		current_option -= 1
		if current_option < 0:
			current_option = options.size()-1
		options[current_option].select()
	# apply option
	if Input.is_action_just_pressed("select"):
		has_chosen_upgrade = true
		var option = options[current_option]
		var upgrade = option.option.object_to_spawn.instantiate()
		if upgrade.is_in_group("gun"):
			option.spawn_gun()
		else:
			option.spawn_upgrade()
		option.destination = option.position + Vector2(0, 350)
		for i in options:
			if i != option:
				i.destination = i.position - Vector2(0, 350)
		upgrade.queue_free()
		destroy()
	# position arm
	$Node2D/DogArm.position = lerp($Node2D/DogArm.position, options[current_option].position, 10 * delta)

func destroy():
	get_tree().paused = false
	await get_tree().create_timer(1.0).timeout
	queue_free()
