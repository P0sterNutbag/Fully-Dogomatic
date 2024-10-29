extends CanvasLayer

var level_obj_sign = preload("res://Scenes/UI/level_object_sign.tscn")
var level_signs: Array[String]
var level_signs_affinity: Array[bool]
var level_signs_amount: Array[int]
var game_time: float
var death_ui = preload("res://Scenes/UI/death_ui.tscn")
@onready var drop_pos_origin = $Drop.position
@onready var drop_timer = $Drop/DropTimer
@onready var level_name = $Label
@onready var stage_name = $Label/RichTextLabel
@onready var hp_bar = $LeftCorner/HPBar/HealthBar
@onready var score = $ScoreHolder/Score
@onready var score_holder = $ScoreHolder
@onready var loadout = $Loadout

func _ready():
	Globals.ui = self
	$Drop.position.y -= 200
	#$Info/GunsAmnt.text = "[right]" + "0" + "/" + "12"
	#Globals.player.player_died.connect(on_player_died)


func _process(delta):
	# drop timer
	var time_left
	if Globals.level_manager.get_node_or_null("Spawn") != null:
		time_left = round(Globals.level_manager.get_node("Spawn").time_left*pow(10,2))/pow(10,2)
	else: 
		time_left = 30
	if time_left < 6:
		$Drop.position = lerp($Drop.position, drop_pos_origin, delta * 5)
		$Drop/DropTimer.text = "[left]" + str(time_left)
	else:
		$Drop.position.y = lerp($Drop.position.y, drop_pos_origin.y - 200, 5 * delta)
	# game time
	game_time += delta
	$Info/TimeAmnt.text = "[right]" + Globals.time_to_minutes_secs_mili(game_time)
	$Info/KillsAmnt.text = "[right]" + str(Globals.world_controller.total_kills)
	#$RightCorner/TimeAmnt.text = "[right]" + str(int(game_time / 60)) + "." + str("%.2f" % fmod(game_time / 60, 60))#str("%.2f" % game_time)	
	# Score
	var kps = Globals.world_controller.kills_per_sec
	score.text = str(kps)
	#if kps > 2:
		#score_holder.visible = true
	#if kps < 1:
		#score_holder.visible = false
	$Info/KPSAmnt2.text = "[right]" + str(kps)



func set_money(money: int):
	$LeftCorner/MoneyText.text = "$" + str(money)


func set_gun_amount(gun_amount: int, gun_cap: int):
	#Globals.gun_amount = Globals.player.guns.size()
	$Info/GunsAmnt.text = "[right]" + str(gun_amount) + "/" + str(gun_cap)
	if gun_amount >= gun_cap:
		Globals.shop_scene = Globals.no_guns_shop
	else:
		Globals.shop_scene = Globals.gun_shop

func add_level_obj(obj_text: String, good: bool, amount: int = 1):
	level_signs.append(obj_text)
	level_signs_affinity.append(good)
	level_signs_amount.append(amount)


func create_level_obj_signs():
	for i in level_signs.size():
		var inst = level_obj_sign.instantiate()
		add_child(inst)
		inst.position = drop_pos_origin + Vector2(-113, (40 + (12 * (i + 1))))
		var num = ""
		if level_signs_amount[i] > 1:
			num += " x" + str(level_signs_amount[i])
		inst.text = "[center]+" + level_signs[i] + num + "!"
		if level_signs_affinity[i] == false:
			inst.add_theme_color_override("default_color", "ff0000")
		await get_tree().create_timer(0.5).timeout
	level_signs.clear()
	level_signs_affinity.clear()


func set_boss_hp(boss_name: String, progress: float):
	$BossHp.visible = true
	$BossHp/BossName.text = "[center]" + boss_name.to_upper()
	$BossHp/HealthBar.value = progress
	if $BossHp/HealthBar.value <= 0:
		#await get_tree().create_timer(3).timeout
		$BossHp.visible = false


func on_player_died():
	var dui = death_ui.instantiate()
	add_child(dui)


func _on_timer_timeout():
	var tween = create_tween()
	tween.tween_property(level_name, "modulate:a", 0, 1)
	tween.tween_callback(level_name.queue_free)
