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


func _ready():
	Globals.audio_manager = self
	if Globals.muted: 
		mute()


func mute():
	var index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(index, !is_muted)
	is_muted = !is_muted
	Globals.muted = is_muted
