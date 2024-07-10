extends Sprite2D

var original_scale


func _ready():
	original_scale = scale
	$Icon.texture = get_parent().get_node("MinimapIcon").sprite
	visible = false


func _process(delta):
	var parent_pos = get_parent().global_position
	var player_pos = Globals.camera.get_screen_center_position()
	if parent_pos.x < player_pos.x - 320 or parent_pos.x > player_pos.x + 320 or parent_pos.y < player_pos.y - 180 or parent_pos.y > player_pos.y + 180:
		global_position.x = clamp(parent_pos.x, player_pos.x - (590 / 2), player_pos.x + (590 / 2))
		global_position.y = clamp(parent_pos.y, player_pos.y - (310 / 2), player_pos.y + (310 / 2))
		look_at(parent_pos)
		if !visible:
			scale = Vector2.ZERO
			visible = true
			var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "scale", original_scale, 0.4)
	else:
		var tween = get_tree().create_tween().set_trans(Tween.TRANS_BOUNCE)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", Vector2.ZERO, 0.3)
		tween.tween_property(self, "visible", false, 0)
	$Icon.global_rotation = 0
