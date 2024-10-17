extends Node2D

var can_restart = false
var time : float = 0
var frequency = 4
var amplitude = 20
var score = 0
var high_score = 0
var game_over: bool = false
var total_kills: int:
	set(value):
		total_kills = value
		kills += 1
var kills: int
var kills_per_sec: int


func _ready():
	Globals.world_controller = self
	Globals.barrier_left = $BarrierLeft.position
	Globals.barrier_right = $BarrierRight.position
	Globals.audio_manager.stage_music.play()
	var player
	if Globals.player == null:
		player = Globals.create_instance(Globals.player_to_spawn, Vector2.ZERO, self)
	else:
		player = Globals.player
		add_child(player)
		player.process_mode = Node.PROCESS_MODE_PAUSABLE
	player.global_position = $PlayerSpawner.global_position
	player.player_died.connect(on_player_died)
		


func _process(delta):
	time += delta
	if time > 1:
		kills_per_sec = kills
		kills = 0
		time = 0
	#if Input.is_key_pressed(KEY_B):
		#spawn_upgrade_menu("guns")
	#if Input.is_key_pressed(KEY_N):
		#spawn_upgrade_menu("upgrades")
	#if game_over and Input.is_key_pressed(KEY_R):
		#pass#start_scene_transition("res://Scenes/Levels/world.tscn")


func reset_scene():
	get_tree().reload_current_scene()


func _on_player_player_died():
	pass


func reset_score():
	if score > high_score:
		high_score = score
	score = 0


func on_player_died():
	game_over = true
