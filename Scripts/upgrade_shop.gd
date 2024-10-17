extends Control

@export var options: Array[Control]
@export var total_picks: int = 3
@export var can_quit: bool = true
var upgrades: Array
var not_enough_money = preload("res://Scenes/UI/not_enough_money.tscn")
var reroll_price: int
var tooltip_string: String
var picks: int = 0
@onready var tooltip = $Tooltip
@onready var place_text = $Title2

func _ready():
	Globals.upgrade_menu = self
	get_tree().paused = true
	assign_upgrades_options()
	global_position += Vector2.DOWN * 400
	move_options_in()
	options[0].grab_focus()
	set_focus_neighbors()
	$Money.text = "Money: $" + str(Globals.player.money)
	if total_picks > 2:
		reroll_price = clamp((3 / (Globals.price_multiplier) * (1 - Globals.player.shop_discount)), 1, 1000)
		$Reroll/RichTextLabel.text = "[center]REROLL \n $" + str(reroll_price)
	await get_tree().create_timer(0.5).timeout
	for inst in get_tree().get_nodes_in_group("particles"):
		inst.queue_free()


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


func finish(delay: float = 0):
	$Money.text = "Money: $" + str(Globals.player.money)
	picks += 1
	if delay > 0:
		await get_tree().create_timer(delay).timeout
	if options.size() > 0 and picks < total_picks:
		move_options_in()
		set_focus_neighbors()
		options[0].grab_focus()
	else:
		queue_free()


func move_options_in():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2.ZERO, 0.5)


func move_options_out():
	$Money.text = "Money: $" + str(Globals.player.money)
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", Vector2.DOWN*360, 0.5)
	for option in options:
		option.release_focus()


func set_focus_neighbors():
	var children = get_children()
	for i in children.size()-1:
		var child = children[i]
		if child is Button:
			child.focus_neighbor_left = children[Globals.scroll_array_index(children, i , -1)].get_path()
			child.focus_neighbor_right = children[Globals.scroll_array_index(children, i , +1)].get_path()


func show_tooltip(pos: Vector2, text: String):
	tooltip.visible = true
	tooltip.global_position = pos
	$Tooltip/RichTextLabel.text = text


func hide_tooltip():
	tooltip.visible = false


func _on_exit_button_pressed() -> void:
	queue_free()


func _on_reroll_pressed() -> void:
	if Globals.player.money >= reroll_price:
		upgrades.clear()
		assign_upgrades_options() 
		Globals.player.spend_money(reroll_price)
		$Money.text = "Money: $" + str(Globals.player.money)
	else:
		var inst = Globals.create_instance(not_enough_money, $Reroll.global_position + Vector2(26.25, 0), self)
		var tween = create_tween()
		tween.tween_property(inst, "global_position", inst.global_position + Vector2.UP * 12, 1)
		tween.tween_callback(inst.queue_free)
