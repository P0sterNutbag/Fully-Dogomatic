extends Area2D

var upgrade: PackedScene
var move_towards_gun: bool = false
var nearest_guns: Array[Area2D]
var gun_to_upgrade: Node2D
var time : float = 0
var frequency = 4
var amplitude = 4

func _ready():
	pass


func _process(delta):
	# highlight closest gun
	if nearest_guns.size() > 0:
		nearest_guns.sort_custom(func(x, y): return x.global_position.distance_to(global_position) < y.global_position.distance_to(global_position))
		for gun in nearest_guns:
			if gun == nearest_guns[0]:
				pass
				#gun.get_node("AnimatedSprite2D").material = new_gun_material
			else:
				gun.reset_material()
	# movement
	if !move_towards_gun:
		time += delta
		var movement = cos(time * frequency) * amplitude
		position.y += movement * delta
	elif gun_to_upgrade != null:
		var target_position = gun_to_upgrade.position
		position = lerp(position, target_position, delta * 10)
		if position.distance_to(target_position) < 2:
			apply_upgrade(gun_to_upgrade)


func _on_area_entered(area):
	if area.is_in_group("gun") and Globals.player.guns.has(area) and not move_towards_gun:
		gun_to_upgrade = area
		move_towards_gun = true


func apply_upgrade(target: Area2D):
	var instance = upgrade.instantiate()
	target.add_child(instance)
	target.reset_material()
	target.upgrades += 1
	Globals.ui_guns.queue_redraw()
	queue_free()


func set_title():
	var inst = upgrade.instantiate()
	$UpgradeName.text = "[center]" + inst.get_meta("Title")
	inst.queue_free()


func _on_area_2d_area_entered(area):
	if area.is_in_group("gun") and Globals.player.guns.has(area) and not move_towards_gun:
		nearest_guns.append(area)


func _on_area_2d_area_exited(area):
	if not move_towards_gun:
		nearest_guns.erase(area)
		area.reset_material()
