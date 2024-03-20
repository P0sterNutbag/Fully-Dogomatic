extends Node2D

@export_subgroup("Properties")
@export var bullet: PackedScene
@export var cooldown: float
@export var damage: float 
@export var spread: float
@export var shot_count: int 
@export var knockback: int
@export var rounds: int
@export var bullet_speed: int 
@export var reload_time: float
@export var penetrations: int
@export var distance_to_player: float
@export var ricochet: bool
@export var explosive: bool
@export var homing: bool

var gun_parent

# Called when the node enters the scene tree for the first time.
func _ready():
	gun_parent = get_parent().get_parent()
	if bullet != null:
		gun_parent.bullet = bullet
	gun_parent.cooldown += cooldown
	gun_parent.damage += damage
	gun_parent.spread += spread
	gun_parent.shot_count += shot_count
	gun_parent.knockback += knockback
	gun_parent.rounds += rounds
	gun_parent.bullet_speed += bullet_speed
	gun_parent.reload_time += reload_time
	gun_parent.penetrations += penetrations
	gun_parent.distance_to_player += distance_to_player
	if ricochet:
		gun_parent.ricochet = ricochet
	if explosive:
		gun_parent.explosive = explosive
	if homing:
		gun_parent.homing = homing
