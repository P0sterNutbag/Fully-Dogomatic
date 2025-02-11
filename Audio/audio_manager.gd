extends Node

var is_muted: bool = false
@export var stage_songs: Array
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
@onready var bullet_impact = $BulletImpact
@onready var select = $Select
@onready var click = $Click
@onready var heal = $Heal


func _ready():
	Globals.audio_manager = self
	if Globals.muted: 
		mute()


func mute():
	var index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(index, !is_muted)
	is_muted = !is_muted
	Globals.muted = is_muted


func play_with_pitch(sound: AudioStreamPlayer2D, variation: float = 0.1):
	if !sound.is_playing():
		sound.pitch_scale = randf_range(1 + variation ,1 - variation)
		sound.play()
	elif sound.get_playback_position() > 0.05:
		sound.pitch_scale = randf_range(1 + variation ,1 - variation)
		sound.play()


func play_if_ready(sound: AudioStreamPlayer2D):
	if !sound.is_playing() or sound.get_playback_position() > 0.05:
		sound.play()


func pause_sounds():
	for child in get_children():
		if child is PausableAudio:
			child.pause_time = child.get_playback_position()
			child.stop()


func resume_sounds():
	for child in get_children():
		if child is PausableAudio:
			if child.pause_time > 0:
				child.play(child.pause_time)


func stop_all_audio():
	for child in get_children():
		child.stop()


func select_stage_music():
	stage_music.stream = stage_songs[randi_range(0, stage_songs.size()-1)]
