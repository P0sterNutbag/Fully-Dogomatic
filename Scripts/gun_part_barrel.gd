extends Node2D

@export_subgroup("Properties")
@export var cooldown: float = 1
@export var shot_count: int = 1
@export var knockback: float = 0
var gun_parent


func _ready():
	gun_parent = get_parent().get_parent()
	if gun_parent is Gun:
		gun_parent.cooldown += cooldown
		gun_parent.get_node("Timer").wait_time = cooldown
		gun_parent.shot_count += shot_count
		gun_parent.knockback += knockback
		gun_parent.firepoint = $Firepoint
		gun_parent.muzzle_flash = $Firepoint/MuzzleFlash
