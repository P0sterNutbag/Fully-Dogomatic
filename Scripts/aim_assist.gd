extends Node2D

var original_aim_dir: Vector2
var target: Node2D


func _ready() -> void:
	original_aim_dir = get_parent().original_aim_dir


func _process(_delta: float) -> void:
	if target != null:
		var new_dir = (target.global_position - get_parent().global_position).normalized()
		if abs(rad_to_deg(new_dir.angle()) - rad_to_deg(original_aim_dir.angle())) < 30:
			get_parent().aim_dir = new_dir
	else:
		get_parent().aim_dir = original_aim_dir


func _on_shape_cast_2d_body_entered(body: Node2D) -> void:
	target = body


func _on_shape_cast_2d_body_exited(body: Node2D) -> void:
	if target == body:
		target = null
