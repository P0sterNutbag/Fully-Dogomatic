extends Area2D

@export var option_array_name: String
@export var options_amount: int
@export var pay_for_guns: bool = false
var shop = preload("res://Scenes/Upgrades/upgrade_menu.tscn")
var target_y: float
var falling = false
var fall_speed = 75
var break_particle = preload("res://Scenes/Particles/wood_particles.tscn")


func _physics_process(delta):
	if falling:
		if position.y <= target_y:
			position.y += fall_speed * delta
		else:
			$FallingSprite.visible = false
			$CrateSprite.visible = true 
			$Shadow.visible = true
			if falling:
				Globals.player.crate_position = global_position
			falling = false


func _on_area_entered(area):
	if !falling and !area.name.contains("Money"):
		var inst = shop.instantiate()
		var upgrade_menu = inst.get_node("UpgradeMenu")
		upgrade_menu.upgrade_array = Globals.upgrade_manager.get(option_array_name)
		upgrade_menu.options_amount = options_amount
		if pay_for_guns:
			for i in upgrade_menu.options:
				i.show_price = true
		var description = upgrade_menu.get_node("ChooseGuns")
		match option_array_name:
			"guns": 
				description.text = "[center]CHOOSE A GUN!"
			"gunparts": 
				description.text = "[center]CHOOSE A GUN PART!"
			"dogtags": 
				description.text = "[center]CHOOSE A DOG TAG!"
		get_tree().current_scene.add_child(inst)
		var particle = break_particle.instantiate()
		get_tree().current_scene.add_child(particle)
		particle.global_position = global_position
		queue_free()
