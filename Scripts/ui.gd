extends CanvasLayer

var level_obj_sign = preload("res://Scenes/UI/level_object_sign.tscn")
var level_signs: Array[String]
var level_signs_affinity: Array[bool]
var game_time: float
@onready var drop_pos_origin = $Drop.position
@onready var drop_timer = $Drop/DropTimer


func _ready():
	Globals.ui = self
	$Drop.position.y -= 200


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
	$RightCorner/TimeAmnt.text = "[right]" + Globals.time_to_minutes_secs_mili(game_time)
	#$RightCorner/TimeAmnt.text = "[right]" + str(int(game_time / 60)) + "." + str("%.2f" % fmod(game_time / 60, 60))#str("%.2f" % game_time)
	


func set_money(money: int):
	$LeftCorner/MoneyText.text = "$" + str(money)


func set_gun_amount():
	Globals.gun_amount = Globals.player.guns.size()
	$RightCorner/GunsAmnt.text = "[right]" + str(Globals.gun_amount) + "/" + str(Globals.player.gun_cap)


func add_level_obj(obj_text: String, good: bool):
	level_signs.append(obj_text)
	level_signs_affinity.append(good)


func create_level_obj_signs():
	for i in level_signs.size():
		var inst = level_obj_sign.instantiate()
		add_child(inst)
		inst.position = drop_pos_origin + Vector2(-113, (40 + (12 * (i + 1))))
		inst.text = "[center]+" + level_signs[i] + "!"
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


