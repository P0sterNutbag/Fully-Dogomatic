extends Node

var is_muted: bool = false

func _ready():
	Globals.audio_manager = self

func mute():
	var index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(index, !is_muted)
	is_muted = !is_muted
