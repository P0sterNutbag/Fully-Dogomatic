extends Node2D

var speed = 150
var list_y_origin
@onready var list = $Mask/SpritesList


func _ready():
	list.position.y += 16 * randi_range(0, 3)
	list_y_origin = list.position.y
	var slow_down = create_tween()
	slow_down.tween_property(self, "speed", 0, 1)


func _process(delta):
	if speed > 0:
		list.position.y += speed * delta
		if list.position.y >= list_y_origin + 48:
			list.position.y = list_y_origin
	else:
		list.position.y = lerp(list.position.y, list_y_origin + floor(list.position.y / 16) * 16, delta * 5)
