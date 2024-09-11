extends Area2D

var free_guns: bool = true
var options_amount: int = 3
var upgrades: Array
var shop = preload("res://Scenes/Upgrades/upgrade_menu.tscn")
@onready var time_left = $TimerText
@onready var timer = $Timer

func _ready() -> void:
	choose_options()


func _process(delta: float) -> void:
	time_left.text = "[center]" + Globals.time_to_minutes_secs_mili(timer.time_left)


func choose_options() -> void:
	upgrades.clear()
	for i in options_amount:
		var all_upgrades = Globals.upgrade_manager.guns
		var rand_index = Globals.get_weighted_index(all_upgrades)
		while upgrades.has(all_upgrades[rand_index]):
			rand_index = Globals.get_weighted_index(all_upgrades)
		upgrades.append(all_upgrades[rand_index])


func _on_area_entered(area):
	if Globals.ui.tutorial != null:
		Globals.ui.tutorial.queue_free()
	var inst = Globals.create_instance(shop)
	var upgrade_menu = inst.get_node("UpgradeMenu")
	upgrade_menu.options_amount = options_amount
	upgrade_menu.upgrade_array = Globals.upgrade_manager.get("guns")
	upgrade_menu.upgrades = upgrades
	if free_guns:
		free_guns = false
		return
	for i in upgrade_menu.options:
		i.show_price = true


func _on_timer_timeout() -> void:
	choose_options()
