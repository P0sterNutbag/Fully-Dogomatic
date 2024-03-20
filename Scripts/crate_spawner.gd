extends Node2D

@export var guns: Array[PackedScene]
var crate = preload("res://Scenes/crate.tscn")
var gun: PackedScene# = preload("res://Scenes/Guns/pistol.tscn")# PackedScene
var target_y: float


func _ready():
	Globals.crate_spawner = self
	pass


func get_random_item_from_array(array):
	var index = randi_range(0, array.size()-1)
	print_debug(array[index])
	return array[index] 


func spawn_crate(gun_to_spawn: PackedScene = null, upgrade_to_spawn: PackedScene = null):
	# spawn crate
	global_position.x = get_parent().global_position.x + randf_range(-50, 50)#randf_range(-720,720)
	target_y = get_parent().global_position.y + randf_range(-50, 50)
	var inst = crate.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
	inst.target_y = target_y
	# choose gun
	if gun_to_spawn == null:
		inst.gun = guns[randi_range(0, guns.size()-1)]
	else:
		inst.gun = gun_to_spawn
		if upgrade_to_spawn != null:
			inst.upgrade = upgrade_to_spawn


func get_files_from_folder(path):
	var array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				array.append(file_name)
				print("Found file: " + file_name)
			file_name = dir.get_next()
		return array
	else:
		print("An error occurred when trying to access the path.")


func _on_timer_timeout():
	position.x = Globals.player.global_position.x + randf_range(-50, 50)#randf_range(-720,720)
	target_y = Globals.player.global_position.y + randf_range(-50, 50)
	spawn_crate()


func reset_timer():
	$Timer.start()
