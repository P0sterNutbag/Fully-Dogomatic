extends Node2D

var can_restart = false
var time : float = 0
var frequency = 4
var amplitude = 20
var score = 0
var high_score = 0
var game_end = false
var particle_round = 1
var upgrade_menu = preload("res://Scenes/Upgrades/upgrade_menu.tscn")

signal stop_spawning_enemies


func _ready():
	Globals.world_controller = self
	Globals.barrier_left = $BarrierLeft.position
	Globals.barrier_right = $BarrierRight.position


func _process(delta):
	time += delta
	var movement = cos(time * frequency) * amplitude
	var rot = cos(time * 2) * 0.15
	$CanvasLayer/GameOverTextHolder.position.y += movement * delta
	$CanvasLayer/GameOverTextHolder.rotation += rot * delta
	$CanvasLayer/ScoreHolder.visible = score > 0
	var rot2 = cos(time * 4) * 0.15
	$CanvasLayer/ScoreHolder.rotation += rot2 * delta
	$CanvasLayer/ScoreHolder/Score.text = str(score)
	$CanvasLayer/ScoreHolder/Score.scale = $CanvasLayer/ScoreHolder/Score.scale.lerp(Vector2(1, 1), 10 * delta)
	#$CanvasLayer/GunsHolder.scale = $CanvasLayer/GunsHolder.scale.lerp(Vector2(1, 1), 10 * delta)
	#var input_axis = Input.get_axis("left", "right")
	#$CanvasLayer/GunsHolder.rotation = lerp($CanvasLayer/GunsHolder.rotation, 0.05 * input_axis, 10 * delta)
	#$CanvasLayer/XpBarHolder.position.y = lerp($CanvasLayer/XpBarHolder.position.y, float(-25), delta)
	if can_restart:
		$CanvasLayer/ScoreHolder.visible = false
		if Input.is_action_just_pressed("restart"):
			var nodes = get_tree().get_nodes_in_group("destroy")
			for node in nodes.size():
				nodes[node].queue_free()
			reset_scene()
	if Input.is_key_pressed(KEY_B):
		spawn_upgrade_menu("guns")
	if Input.is_key_pressed(KEY_N):
		spawn_upgrade_menu("gunparts")
	if Input.is_key_pressed(KEY_M):
		spawn_upgrade_menu("dogtags")


func reset_scene():
	get_tree().reload_current_scene()


func _on_player_player_died():
	can_restart = true
	$CanvasLayer/Countdown.queue_free()
	$CanvasLayer/GameOverTextHolder.visible = true
	$CanvasLayer/ScoreHolder.visible = false
	$CanvasLayer/HighScoreHolder.visible = true
	$CanvasLayer/GunsHolder.visible = false
	$CanvasLayer/HighScoreHolder/HighScore.append_text(str(high_score))
	$DeathMusic.play()
	$Music.stop()
	stop_enemies()
	stop_guns()
	delete_pickups()
	#reset_scene()

func increase_score():
	score += 1
	$CanvasLayer/ScoreHolder/Score.scale = Vector2(1.3, 1.3)


func add_to_gun_list(string):
	$CanvasLayer/GunsHolder/Guns.append_text("\n" + string)
	$CanvasLayer/GunsHolder.scale = Vector2(1.25, 1.25)


func set_money(val):
	$CanvasLayer/XpBarHolder/XpBar.value = val


func reset_score():
	if score > high_score:
		high_score = score
	score = 0


func _on_countdown_end_game():
	game_end = true
	can_restart = true
	$CanvasLayer/WinHolder.visible = true
	$CanvasLayer/HighScoreHolder.visible = true
	$CanvasLayer/GameOverTextHolder.visible = true
	$CanvasLayer/HighScoreHolder/HighScore.append_text(str(high_score))
	$CanvasLayer/ScoreHolder.visible = false
	$CanvasLayer/Countdown.visible = false
	$CanvasLayer/GunsHolder.visible = false
	$CanvasLayer/ParticlesTimer.start()
	stop_enemies()
	stop_guns()
	delete_pickups()

func stop_enemies():
	stop_spawning_enemies.emit()
	var enemies = get_tree().get_nodes_in_group("enemy")  
	for enemy in enemies:
		if enemy.is_class("CharacterBody2D"):
			enemy.game_over = true


func stop_guns():
	var enemies = get_tree().get_nodes_in_group("gun")  
	for enemy in enemies:
			enemy.set_game_over()


func delete_pickups():
	var pickups = get_tree().get_nodes_in_group("destroy")  
	for pickup in pickups:
			pickup.queue_free()


func _on_particles_timer_timeout():
	var particles
	if particle_round == 1:
		particles = $CanvasLayer/ParticlesGroup1.get_children()
	if particle_round == 2:
		particles = $CanvasLayer/ParticlesGroup2.get_children()
	if particle_round == 3:
		particles = $CanvasLayer/ParticlesGroup3.get_children()
	particle_round += 1
	for particle in particles:
		particle.start()
	if particle_round > 3:
		particle_round = 1


func spawn_upgrade_menu(type: String):
	var instance = upgrade_menu.instantiate()
	instance.get_node("UpgradeMenu").upgrade_array = Globals.upgrade_manager.get(type)
	get_tree().get_root().add_child(instance)
	#instance.global_position = Globals.player.global_position


func _on_player_level_up(level):
	$CanvasLayer/XpBarHolder/Level.text = "LVL " + str(level)


func _on_player_money_pickup():
	$CanvasLayer/XpBarHolder.position.y = 0
