extends Node

var is_muted: bool = false
@onready var chaching = $Chaching
@onready var reload = $Reload
@onready var gunshot = $Gunshot
@onready var explosion = $Explosion
@onready var bark = $Bark

func _ready():
	Globals.audio_manager = self
	if Globals.muted: 
		mute()


func mute():
	var index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(index, !is_muted)
	is_muted = !is_muted
	Globals.muted = is_muted
