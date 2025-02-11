extends Node

@export var steps: Array[CutsceneStep]
@export var kill_enemies: bool
var explosion = preload("res://Scenes/Particles/death_explosion.tscn")
var big_explosion = preload("res://Scenes/Bullets/bullet_explosion.tscn")
var win_screen = preload("res://Scenes/Levels/win_screen.tscn")
var step: int = 0


func _ready():
	delete_effects()
	get_tree().paused = true
	next_step()
	#for step in steps:
		#var callable = Callable(self, step.function)
		#callable.call()
		#await get_tree().create_timer(step.wait_time).timeout
	#queue_free()


func next_step():
	if step >= steps.size():
		queue_free()
	else:
		var callable = Callable(self, steps[step].function)
		step += 1
		callable.call()


func _exit_tree():
	var inst = win_screen.instantiate()
	Globals.ui.add_child(inst)
	#get_tree().paused = false
	#if kill_enemies:
		#for enemy in get_tree().get_nodes_in_group("enemy"):
			#if enemy.name == "Hurtbox":
				#enemy.take_damage(10000, 0)
	#for gun in Globals.player.guns:
		#gun.get_node("ShootTimer").stop()
		#gun.get_node("ReloadTimer").stop()
	#AudioManager.stage_music.stream_paused = true


func delete_effects():
	var effects = get_tree().get_nodes_in_group("effects")
	for i in effects:
		i.queue_free()


func move_camera_on_boss():
	#var cam_pos = Globals.camera.global_position
	#Globals.player.remove_child(Globals.camera)
	#get_parent().add_child(Globals.camera)
	#Globals.camera.global_position = cam_pos
	var pos = get_parent().get_node("Boss").global_position + Vector2.UP * 75
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(Globals.camera, "global_position", pos, 1)
	tween.tween_callback(next_step)


func boss_explosions():
	for i in 20:
		var pos = get_parent().get_node("Boss").global_position
		var inst = Globals.create_instance(explosion, pos + Vector2(randf_range(-100,100), randf_range(-100,0)))
		inst.process_mode = PROCESS_MODE_ALWAYS
		inst.z_index = 900
		Globals.audio_manager.explosion.play()
		await get_tree().create_timer(0.15).timeout
	next_step()


func big_boss_explosion():
	var pos = get_parent().get_node("Boss").global_position + Vector2.UP * 75
	var inst = Globals.create_instance(big_explosion, pos)
	inst.process_mode = PROCESS_MODE_ALWAYS
	inst.scale = Vector2.ONE * 10
	inst.z_index = 900
	Globals.audio_manager.explosion.play()
	next_step()


func destroy_boss():
	get_parent().get_node("Boss").queue_free()
	await get_tree().create_timer(1).timeout
	next_step()


func reset_camera():
	var tween = create_tween().set_trans(Tween.TRANS_SINE)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(Globals.camera, "position", Vector2.ZERO, 1)
	tween.tween_callback(next_step)


func go_to_next_level():
	var next_level
	match Globals.world_controller.name:
		"World 1":
			SaveData.stage1 = true
		"World 2":
			SaveData.stage2 = true
		#"World 3":
			##SaveData.stage2 = true
		#"World 4":
			#next_level = "res://Scenes/Levels/end.tscn"
	SaveData.save_game()
	#Globals.create_instance(level_summary, Vector2.ZERO, Globals.ui)
	#SceneManager.start_scene_transition("res://Scenes/Levels/main_menu.tscn")
