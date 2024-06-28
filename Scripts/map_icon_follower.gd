extends Sprite2D

var follow_obj: Node2D
var level_width: float
var level_height: float
var map_width: float
var map_height: float


func _process(_delta):
	if follow_obj != null:
		var x_ratio = follow_obj.position.x / level_width
		var y_ratio = follow_obj.position.y / level_height
		position.x = clamp(map_width * x_ratio, -map_width/2 + texture.get_width() / 2, map_width/2 - texture.get_width() / 2)
		position.y = clamp(map_height * y_ratio, -map_height/2 + texture.get_height() / 2, map_height/2 - texture.get_height() / 2)
