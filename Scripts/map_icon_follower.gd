extends Sprite2D

var follow_obj: Node2D
var level_width: float
var level_height: float
var map_width: float
var map_height: float
var time: float


func _process(delta):
	time += delta
	if follow_obj != null and fmod(time, 0.1) < delta:
		var x_ratio = follow_obj.position.x / level_width
		var y_ratio = follow_obj.position.y / level_height
		position.x = clamp(map_width * x_ratio, texture.get_width() / 2, map_width - texture.get_width() / 2)
		position.y = clamp(map_height * y_ratio, texture.get_height() / 2, map_height - texture.get_height() / 2)
