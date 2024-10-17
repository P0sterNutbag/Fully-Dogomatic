extends Node2D

var target: Node2D


func _process(_delta: float) -> void:
	var original_aim_dir = get_parent().original_aim_dir
	global_rotation = original_aim_dir.angle()
	var targets = $ShapeCast2D.get_overlapping_areas()
	if targets.size() > 0:
		targets.sort_custom(sort_distance)
		target = targets[targets.size()-1]
		if target != null:
			var new_dir = (target.global_position - get_parent().global_position).normalized()
			if abs(abs(rad_to_deg(new_dir.angle())) - abs(rad_to_deg(original_aim_dir.angle()))) < 30:
				get_parent().aim_dir = new_dir
		else:
			get_parent().aim_dir = original_aim_dir
	else:
		get_parent().aim_dir = original_aim_dir


func sort_distance(a, b):
	if global_position.distance_to(a.global_position) < global_position.distance_to(b.global_position):
		return a
	return b

#func _on_shape_cast_2d_body_entered(body: Node2D) -> void:
	#target = body
#
#
#func _on_shape_cast_2d_body_exited(body: Node2D) -> void:
	#if target == body:
		#target = null
