extends Node

var is_muted: bool = false
@onready var chaching = $Chaching
@onready var reload = $Reload
@onready var gunshot_pistol = $GunshotPistol
@onready var gunshot_shotgun = $GunshotShotgun
@onready var gunshot_rifle = $GunshotRifle
@onready var gunshot_smg = $GunshotSMG
@onready var gunshot_revolver = $GunshotRevolver
@onready var gunshot_assault = $GunshotAssault
@onready var explosion = $Explosion
@onready var stage_music = $StageMusic
@onready var bark = $Bark
@onready var menu_music = $MenuMusic


func _ready():
	Globals.audio_manager = self
	if Globals.muted: 
		mute()


func mute():
	var index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(index, !is_muted)
	is_muted = !is_muted
	Globals.muted = is_muted


func pause_sounds():
	for child in get_children():
		child.pause_time = child.get_playback_position()
		child.stop()


func resume_sounds():
	for child in get_children():
		if child.pause_time > 0:
			child.play(child.pause_time)


func stop_all_audio():
	for child in get_children():
		child.stop()

