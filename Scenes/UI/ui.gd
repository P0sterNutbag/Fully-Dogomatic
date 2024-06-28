extends CanvasLayer

var level_obj_sign = preload("res://Scenes/UI/level_object_sign.tscn")
var level_signs: Array[String]
@onready var drop_pos_origin = $Drop.position
@onready var drop_timer = $Drop/DropTimer


func _ready():
	Globals.ui = self
	$Drop.position.y -= 200


func _process(delta):
	var time_left = round(Globals.level_manager.get_node("Spawn").time_left*pow(10,2))/pow(10,2)
	if time_left < 10:
		$Drop.position = lerp($Drop.position, drop_pos_origin, delta * 5)
		$Drop/DropTimer.text = "[left]" + str(time_left)
	else:
		$Drop.position.y = lerp($Drop.position.y, drop_pos_origin.y - 200, 5 * delta)


func set_money(money: int):
	$Money/MoneyText.text = "$" + str(money)


func add_level_obj(obj_text: String):
	level_signs.append(obj_text)


func create_level_obj_signs():
	for i in level_signs.size():
		var inst = level_obj_sign.instantiate()
		add_child(inst)
		inst.position = drop_pos_origin + Vector2(-113, (40 + (10 * (i + 1))))
		inst.text = "[center]+" + level_signs[i] + "!"
		await get_tree().create_timer(0.5).timeout
	level_signs.clear()

