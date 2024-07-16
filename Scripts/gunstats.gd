extends Control

@export var gui_layer: CanvasLayer
const position_offset = Vector2(10, 10)
var damage_min = 0
var damage_max = 10
var firerate_min = 2
var firerate_max = 0.01
var accuracy_max = 0
var accuracy_min = 30
var magazine_min = 1
var magazine_max = 30
@onready var damage_bar = $PanelContainer/MarginContainer/VBoxContainer/Damage/ProgressBar
@onready var firerate_bar = $PanelContainer/MarginContainer/VBoxContainer/FireRate/ProgressBar
@onready var accuracy_bar = $PanelContainer/MarginContainer/VBoxContainer/Accuracy/ProgressBar
@onready var magsize_bar = $PanelContainer/MarginContainer/VBoxContainer/MagSize/ProgressBar
@onready var bullets_per_shot = $PanelContainer/MarginContainer/VBoxContainer/BulletsPerShot/BPS
@onready var reaload_speed = $PanelContainer/MarginContainer/VBoxContainer/ReloadSpeed/RS
@onready var gun_name = $PanelContainer/MarginContainer/VBoxContainer/GunName


func _ready():
	Globals.gunstats = self


func _process(_delta):
	if visible:
		position = get_global_mouse_position() + position_offset


func set_stats(gun: Node2D):
	gun_name.text = gun.get_meta("Title").to_upper()
	var bullet = gun.bullet.instantiate()
	damage_bar.value = get_value(bullet.damage * bullet.shot_count, damage_max, 0)
	firerate_bar.value = get_value(gun.cooldown, firerate_max, firerate_min)
	accuracy_bar.value = get_value(gun.spread + bullet.spread_modifier, accuracy_max, accuracy_min)
	magsize_bar.value = get_value(gun.rounds, magazine_min, magazine_max)
	bullets_per_shot.text = str(gun.shot_count)
	reaload_speed.text = str(gun.get_node("ReloadTimer").wait_time) + " sec"
	bullet.queue_free()


func get_value(val: float, max_val: float, min_val: float) -> float:
	return (val - min_val) / (max_val - min_val) * 100
