extends Node

@onready var scene_transition = $CanvasLayer/CircleTransition
@onready var loading_sprite = $CanvasLayer/LoadingSprite
@onready var animation_player = $CanvasLayer/LoadingSprite/AnimationPlayer
var next_scene: String
var pause_music: bool


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	scene_transition.transition_in_done.connect(start_load)
	loading_sprite.visible = false
	set_process(false)


func start_scene_transition(scene: String, stop_music: bool = true) -> void:
	scene_transition.transition_in()
	next_scene = scene
	pause_music = stop_music


func change_scene() -> void:
	#if Globals.player != null:
		#Globals.player.process_mode = PROCESS_MODE_DISABLED
		#Globals.world_controller.remove_child(Globals.player)
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene))
	scene_transition.transition_out()
	if !next_scene.contains("main_menu"):
		animation_player.play("popout")


func start_load() -> void:
	ResourceLoader.load_threaded_request(next_scene)
	set_process(true)
	if !next_scene.contains("main_menu"):
		animation_player.play("popin")
	if pause_music:
		AudioManager.stop_all_audio()


func _process(_delta):
	var load_status = ResourceLoader.load_threaded_get_status(next_scene)
	match load_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			change_scene()
			set_process(false)
		ResourceLoader.THREAD_LOAD_FAILED:
			print("THREAD_LOAD_FAILED")
	
