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
@onready var circle_transition = $CanvasLayer/CircleTransition

signal stop_spawning_enemies


func _ready():
	Globals.world_controller = self
	Globals.barrier_left = $BarrierLeft.position
	Globals.barrier_right = $BarrierRight.position
	circle_transition.visible = true
	circle_transition.transition_out()


func _process(delta):
	if Input.is_key_pressed(KEY_B):
		spawn_upgrade_menu("guns")
	if Input.is_key_pressed(KEY_N):
		spawn_upgrade_menu("gunparts")
	if Input.is_key_pressed(KEY_M):
		spawn_upgrade_menu("dogtags")


func reset_scene():
	get_tree().reload_current_scene()


func _on_player_player_died():
	pass

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


func spawn_upgrade_menu(type: String):
	var instance = upgrade_menu.instantiate()
	instance.get_node("UpgradeMenu").upgrade_array = Globals.upgrade_manager.get(type)
	get_tree().get_root().add_child(instance)


func start_scene_transition(scene_path: String):
	circle_transition.transition_in()
	circle_transition.transition_in_done.connect(Callable(self, "change_scene").bind(scene_path))


func change_scene(scene_path: String):
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file(scene_path)

