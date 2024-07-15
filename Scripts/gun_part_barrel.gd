extends GunPart

@export_subgroup("Properties")
@export var bullet_damage: float = 3
@export var cooldown: float = 1
@export var spread: float = 0
@export var knockback: float = 0
@export var distance_to_player: float = 30
@export var bullet: PackedScene
var gun_parent


func set_gun_stats():
	gun_parent = get_parent().get_parent()
	if gun_parent is Gun:
		gun_parent.cooldown = cooldown
		gun_parent.spread = spread
		gun_parent.get_node("Timer").wait_time = cooldown
		gun_parent.knockback = knockback
		gun_parent.firepoint = $Firepoint
		gun_parent.muzzle_flash = $Firepoint/MuzzleFlash
		gun_parent.distance_to_player = distance_to_player
		gun_parent.bullet = bullet
		gun_parent.bullet_damage = bullet_damage
