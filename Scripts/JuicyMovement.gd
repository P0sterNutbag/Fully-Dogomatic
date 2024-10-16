extends Node2D

@export var target_control : Control
@export var target_node2D : Node2D
@export var bob_frequency: float = 0
@export var bob_amplitude: float = 0
@export var shake_frequency: float = 0
@export var shake_amplitude: float = 0
@export var pulse_frequency: float = 0
@export var pulse_amplitude: float = 0
@export var rot_frequency: float = 0
@export var rot_amplitude: float = 0
@export var blink_frequency: float = 0
var target
var blink_timer: Timer
var time : float = 0


func _ready():
	if target_control != null:
		target = target_control
	elif target_node2D != null:
		target = target_node2D
	if blink_frequency > 0:
		blink_timer = Timer.new()
		add_child(blink_timer)
		blink_timer.wait_time = blink_frequency
		blink_timer.timeout.connect(blink)
		blink_timer.start()


func _process(delta):
	if target != null:
		time += delta
		var bob = cos(time * bob_frequency) * bob_amplitude
		target.position.y += bob * delta
		var shake = cos(time * shake_frequency) * shake_amplitude
		target.position.x += shake * delta
		var pulse = cos(time * pulse_frequency) * pulse_amplitude
		target.scale.x += pulse * delta
		target.scale.y += pulse * delta
		var rot = cos(time * rot_frequency) * rot_amplitude
		target.rotation_degrees += rot * delta

func blink():
	target.visible = !target.visible
