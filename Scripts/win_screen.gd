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
	var alerts = unlock_characters()
	for alert in alerts:
		add_child(alert)
		await alert.tree_exited
	buttons.process_mode = Node.PROCESS_MODE_INHERIT
	super._ready()
	if Globals.player.name == "Character0":
		SaveData.c0_win = true
	if Globals.player.name == "Character1":
		SaveData.c1_win = true
	if Globals.player.name == "Character2":
		SaveData.c2_win = true
	if Globals.player.name == "Character3":
		SaveData.c3_win = true
	if Globals.player.name == "Character4":
		SaveData.c4_win = true
	SaveData.save_game()
	if SaveData.c0_win and SaveData.c1_win and SaveData.c2_win and SaveData.c3_win and SaveData.c4_win:
		Globals.set_achievement("completion")


func unlock_characters() -> Array:
	var unlocked_characters: Array
	if !SaveData.character1:
		unlocked_characters.append(1)
		SaveData.character1 = true
		Globals.set_achievement("unlock_a_character")
	if !SaveData.character2:
		unlocked_characters.append(2)
		SaveData.character2 = true
	if !SaveData.character3:
		unlocked_characters.append(3)
		SaveData.character3 = true
	if !SaveData.character4:
		unlocked_characters.append(4)
		SaveData.character4 = true
	var alerts: Array
	for i in unlocked_characters:
		var inst = alert_scene.instantiate()
		alerts.append(inst)
		inst.position = size / 2
		inst.set_character(i)
		SaveData.save_game()
	return alerts


func _on_continue_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_return_pressed() -> void:
	get_tree().paused = false
	SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
