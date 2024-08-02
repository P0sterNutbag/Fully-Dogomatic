extends Control
class_name Menu

var options: Array[Control]
var option_index: int = -1


func _ready():
	for option in get_children():
		if option is MenuOption:
			options.append(option)


func _process(_delta):
	if Input.is_action_just_pressed("up") or Input.is_action_just_pressed("down"):
		change_index(int(Input.get_axis("up", "down")))
	if Input.is_action_just_pressed("enter"):
		if option_index >= 0 and option_index <= options.size():
			options[option_index].on_press.emit()


func change_index(change_int: int):
	var new_index = option_index + change_int
	if new_index < 0:
		new_index = options.size()-1
	elif new_index > options.size()-1:
		new_index = 0
	option_index = new_index
	set_new_index(option_index)


func set_new_index(new_index: int):
	option_index = new_index
	for i in options.size():
		var option = options[i]
		var oi = option.get_index()-1
		if oi == option_index:
			option.grow()
		else:
			option.shrink()
