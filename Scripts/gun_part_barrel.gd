extends GunPart

@export_subgroup("Properties")
@export var bullet_damage: float = 3
@export var bullet_penetrations: int = 1
@export var shot_count: int = 1
@export var cooldown: float = 1
@export var spread: float = 0
@export var knockback: float = 0
@export var distance_to_player: float = 30
@export var bullet: PackedScene
@export var bullet_explosion: PackedScene = preload("res://Scenes/Bullets/bullet_explosion.tscn")
@export var gunshot_sfx: String = "gunshot_pistol"
var gun_parent


func set_gun_stats():
	gun_parent = get_parent().get_parent()
	if gun_parent is Gun:
		gun_parent.cooldown = cooldown
		gun_parent.spread = spread
		gun_parent.cooldown = cooldown
		gun_parent.knockback = knockback
		gun_parent.firepoint = $Firepoint
		gun_parent.muzzle_flash = $Firepoint/MuzzleFlash
		gun_parent.distance_to_player = distance_to_player
		gun_parent.bullet = bullet
		gun_parent.bullet_damage = bullet_damage
		gun_parent.gunshot_sfx = Globals.audio_manager.get(gunshot_sfx)
		gun_parent.penetrations = bullet_penetrations
		gun_parent.shot_count = shot_count
		gun_parent.bullet_explosion = bullet_explosion
