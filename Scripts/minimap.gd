extends Control

var level_width: float
var level_height: float
var x_ratio: float
var y_ratop: float
var player: Node2D
var icon = preload("res://Scenes/UI/map_icon.tscn")
@onready var map = $Mask/Anchor/Map


func _ready():
	var barrier_left = get_tree().current_scene.get_node("BarrierLeft")
	var barrier_right = get_tree().current_scene.get_node("BarrierRight")
	level_width = abs(barrier_right.position.x) + abs(barrier_left.position.x)
	level_height = abs(barrier_right.position.y) + abs(barrier_left.position.y)
	player = Globals.player


func add_to_map(texture: Texture2D, pos: Vector2, follow_obj: Node2D = null) -> Sprite2D:
	var sprite = icon.instantiate()
	map.add_child(sprite)
	sprite.texture = texture
	var x_ratio = pos.x / level_width
	var y_ratio = pos.y / level_height
	sprite.position.x = map.size.x * x_ratio
	sprite.position.y = map.size.y * y_ratio
	sprite.use_parent_material = true
	if follow_obj != null:
		#sprite.set_script(load("res://Scripts/map_icon_follower.gd"))
		sprite.level_width = level_width
		sprite.level_height = level_height
		sprite.map_width = map.size.x
		sprite.map_height = map.size.y
		sprite.follow_obj = follow_obj
	return sprite


func close_map():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.3)


func open_map():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3)

