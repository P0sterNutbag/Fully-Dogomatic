extends UiMenu

var alert_scene = preload("res://Scenes/UI/unlock_alert.tscn")
@onready var kills_stat = $Node2D/VBoxContainer2/Kills2
@onready var kps_stat = $Node2D/VBoxContainer2/KPS2
@onready var guns_stat = $Node2D/VBoxContainer2/Guns2
@onready var buttons = $Node2D/Buttons


func _ready():
	get_tree().paused = true
	# animate stats
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	tween.tween_property(kills_stat, "text", str(Globals.world_controller.total_kills), 0.5)
	tween.tween_property(kps_stat, "text", str(Globals.world_controller.max_kps), 0.5)
	tween.tween_property(guns_stat, "text", str(Globals.player.guns.size()), 0.5)
	await tween.finished
	var alert = unlock_characters()
	if alert:
		await alert.tree_exited
	buttons.process_mode = Node.PROCESS_MODE_INHERIT
	super._ready()


func unlock_characters() -> Control:
	var characters: Array
	for i in 5:
		characters.append(SaveData.get("character"+str(i)))
	for i in characters.size()-1:
		if i == Globals.player.character_index and characters[i] and !characters[i + 1]:
			var inst = alert_scene.instantiate()
			add_child(inst)
			inst.position = size / 2
			inst.set_character(Globals.player.character_index + 1)
			if i == 0 and !SaveData.character1:
				SaveData.character1 = true
			elif i == 1 and !SaveData.character2:
				SaveData.character2 = true
			elif i == 2 and !SaveData.character3:
				SaveData.character3 = true
			elif i == 3 and !SaveData.character4:
				SaveData.character4 = true
			SaveData.save_game()
			return inst
	return null


func _on_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_return_pressed() -> void:
	get_tree().paused = false
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
