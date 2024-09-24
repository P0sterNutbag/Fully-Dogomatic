extends Control

@export var options: Array[Control]
@export var only_one_pick: bool = false
@export var can_quit: bool = true
var upgrades: Array
var not_enough_money = preload("res://Scenes/UI/not_enough_money.tscn")
var reroll_price: int
signal gun_selected
signal upgrade_assigned


func _ready():
	Globals.upgrade_menu = self
	get_tree().paused = true
	assign_upgrades_options()
	global_position += Vector2.DOWN * 400
	move_options_in()
	options[0].grab_focus()
	set_focus_neighbors()
	$Money.text = "Money: $" + str(Globals.player.money)
	if !only_one_pick:
		reroll_price = 3 / (Globals.enemy_spawn_controller.spawn_time[Globals.enemy_spawn_controller.spawn_round] * 2)
		$Reroll/RichTextLabel.text = "[center]REROLL \n $" + str(reroll_price)


func _process(delta):
	pass
	#if Input.is_action_just_pressed("ui_cancel") and can_quit:
		#queue_free()


func assign_upgrades_options():
	for option in options:
		var upgrade_array: Array
		for array_name in option.upgrade_array:
			var array = Globals.upgrade_manager.get(array_name)
			for item in array:
				upgrade_array.append(item)
		#var upgrade_array = Globals.upgrade_manager.get(option.upgrade_array)
		var rand_index = Globals.get_weighted_index(upgrade_array)
		while upgrades.has(upgrade_array[rand_index]):
			rand_index = Globals.get_weighted_index(upgrade_array)
		upgrades.append(upgrade_array[rand_index])
		option.create_upgrade(upgrade_array[rand_index].object_to_spawn)
	for i in options.size():
		if options[i] == null:
			options.remove_at(i)


func _exit_tree():
	get_tree().paused = false


func finish():
	if options.size() > 0 and !only_one_pick:
		move_options_in()
	else:
		queue_free()


func move_options_in():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2.ZERO, 0.5)
	set_focus_neighbors()
	options[0].grab_focus()


func move_options_out():
	$Money.text = "Money: $" + str(Globals.player.money)
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", Vector2.DOWN*400, 0.5)
	for option in options:
		option.release_focus()


func set_focus_neighbors():
	var children = get_children()
	for i in children.size()-1:
		var child = children[i]
		child.focus_neighbor_left = children[Globals.scroll_array_index(children, i , -1)].get_path()
		child.focus_neighbor_right = children[Globals.scroll_array_index(children, i , +1)].get_path()


func _on_exit_button_pressed() -> void:
	queue_free()


func _on_reroll_pressed() -> void:
	if Globals.player.money >= reroll_price:
		upgrades.clear()
		assign_upgrades_options() 
		Globals.player.spend_money(reroll_price)
	else:
		var inst = Globals.create_instance(not_enough_money, $Reroll.global_position + Vector2(26.25, 0), self)
		var tween = create_tween()
		tween.tween_property(inst, "global_position", inst.global_position + Vector2.UP * 12, 1)
		tween.tween_callback(inst.queue_free)
