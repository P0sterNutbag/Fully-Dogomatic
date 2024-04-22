extends Control

@export var gui_layer: CanvasLayer
const position_offset = Vector2(10, 10)
var damage_min = 0
var damage_max = 2
var firerate_min = 0
var firerate_max = 1
var accuracy_min = 0
var accuracy_max = 50
var magazine_min = 1
var magazine_max = 30
@onready var damage_bar = $Damage/ProgressBar
@onready var firerate_bar = $FireRate/ProgressBar
@onready var accuracy_bar = $Accuracy/ProgressBar
@onready var magsize_bar = $MagSize/ProgressBar
@onready var bullets_per_shot = $BulletsPerShot
@onready var reaload_speed = $ReloadSpeed


func _ready():
	Globals.gunstats = self


func _process(_delta):
	if visible:
		position = get_global_mouse_position() + position_offset


func set_stats(gun: Node2D):
	var bullet = gun.bullet.instantiate()
	damage_bar.value = get_value(gun.bullet.instantiate().damage, damage_max, 0, false)
	firerate_bar.value = get_value(gun.cooldown, firerate_max, firerate_min, true)
	accuracy_bar.value = get_value(gun.spread, accuracy_max, accuracy_min, true)
	magsize_bar.value = get_value(gun.rounds, magazine_min, magazine_max, true)
	bullets_per_shot.text = str(gun.shot_count)
	bullet.queue_free()


func get_value(val: float, max_val: float, min_val: float, flip: bool) -> float:
	if flip: return 100 - ((val - min_val) / (max_val - min_val) * 100)
	return (val - min_val) / (max_val - min_val) * 100
