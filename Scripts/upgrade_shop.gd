extends Control

@export var options: Array[Control]
@export var total_picks: int = 3
@export var can_quit: bool = true
var upgrades: Array
var not_enough_money = preload("res://Scenes/UI/not_enough_money.tscn")
var reroll_price: float
var tooltip_string: String
var picks: int = 0
var upgrade_to_delete: Control
var can_pause: bool = true
var can_buy: bool = true
var exit_button: Button
@onready var tooltip = $Tooltip
@onready var place_text = $Title2


func _ready():
	exit_button = get_node_or_null("ExitButton")
	if Globals.player.money < 15:
		$UpgradeOption.upgrade_array.erase("uncommon_guns")
	Globals.upgrade_menu = self
	get_tree().paused = true
	assign_upgrades_options()
	global_position += Vector2.DOWN * 400
	move_options_in()
	options[0].grab_focus()
	set_focus_neighbors()
	$Money.text = "Money: $" + str(Globals.player.money)
	if total_picks > 2:
		if Globals.player.ability == Globals.player.abilities.free_reroll:
			reroll_price = 0
		else:
			reroll_price = 1 #clamp(((Globals.price_multiplier) * (1 - Globals.player.shop_discount)), 1, 1000)
		$Reroll/RichTextLabel.text = "[center]REROLL \n $" + str(round(reroll_price))
	await get_tree().create_timer(0.5).timeout
	for inst in get_tree().get_nodes_in_group("particles"):
		inst.visible = false


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back") and can_pause and exit_button:
		exit_button.grab_focus()


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
	for inst in get_tree().get_nodes_in_group("particles"):
		inst.visible = false
	get_tree().paused = false


func finish(delay: float = 0.1):
	if upgrade_to_delete:
		upgrade_to_delete.queue_free()
	$Money.text = "Money: $" + str(Globals.player.money)
	picks += 1
	await get_tree().create_timer(delay).timeout
	if options.size() > 0 and picks < total_picks:
		move_options_in()
		set_focus_neighbors.call_deferred()
		options[0].grab_focus()
	else:
		queue_free()


func refund():
	Globals.player.money += upgrade_to_delete.price
	$Money.text = "Money: $" + str(Globals.player.money)
	#Globals.ui.set_money(Globals.player.money)
	upgrade_to_delete.scale = Vector2.ONE
	upgrade_to_delete.create_upgrade(upgrade_to_delete.upgrade_scene)
	move_options_in()
	#set_focus_neighbors.call_deferred()
	options[0].grab_focus()


func move_options_in():
	var tween = create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2.ZERO, 0.5)
	tween.tween_property(self, "can_pause", true, 0)
	can_buy = true


func move_options_out():
	can_pause = false
	can_buy = false
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
	AudioManager.select.play()
	queue_free()


func _on_reroll_pressed() -> void:
	AudioManager.select.play()
	if Globals.player.money >= round(reroll_price):
		upgrades.clear()
		assign_upgrades_options() 
		Globals.player.spend_money(reroll_price)
		$Money.text = "Money: $" + str(Globals.player.money)
		reroll_price += 1
		if reroll_price == 0:
			reroll_price = clamp(((Globals.price_multiplier) * (1 - Globals.player.shop_discount)), 1, 1000)
		$Reroll/RichTextLabel.text = "[center]REROLL \n $" + str(round(reroll_price))
	else:
		var inst = Globals.create_instance(not_enough_money, $Reroll.global_position + Vector2(26.25, 0), self)
		var tween = create_tween()
		tween.tween_property(inst, "global_position", inst.global_position + Vector2.UP * 12, 1)
		tween.tween_callback(inst.queue_free)
