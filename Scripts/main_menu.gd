extends Node2D

var options: Array
var option_index: int = -1
@export var options_parent: Node
@onready var circle_transition = $CanvasLayer/CircleTransition


func _ready():
	options = options_parent.get_children()
	for option in options:
		option.on_press.connect(Callable(self, option.function_name))
	#change_index(0)
	circle_transition.visible = true
	circle_transition.transition_out()


func _process(_delta):
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		change_index(int(Input.get_axis("up", "down")))
	if Input.is_action_just_pressed("select"):
		if option_index >= 0 and option_index <= options.size():
			options[option_index].on_press.emit()


func change_index(change_int: int):
	var new_index = option_index + change_int
	if new_index < 0:
		new_index = options.size() - 1
	elif new_index > options.size() - 1:
		new_index = 0
	option_index = new_index
	for i in options.size():
		var option = options[i]
		option.target_scale = Vector2.ONE
		if option.get_index() == option_index:
			option.target_scale = Vector2.ONE * 1.25


func set_new_index(new_index: int):
	option_index = new_index
	for i in options.size():
		var option = options[i]
		option.target_scale = Vector2.ONE
		if option.get_index() == option_index:
			option.target_scale = Vector2.ONE * 1.25


func play():
	start_scene_transition("res://Scenes/Levels/world.tscn")


func start_scene_transition(next_scene: String):
	circle_transition.transition_in()
	circle_transition.transition_in_done.connect(Callable(self, "change_scene").bind(next_scene))


func change_scene(next_scene: String):
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(next_scene)


func open_steam_page():
		var steam_url = "steam://store/2864370"
		OS.shell_open(steam_url)


func open_options():
	pass


func quit():
	get_tree().quit()
