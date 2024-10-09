extends Node


var config = ConfigFile.new()
const file_path = "user://settings.ini"


func _ready() -> void:
	if !FileAccess.file_exists(file_path):
		config.set_value("settings", "sfx_volume", 1.0)
		config.set_value("settings", "music_volume", 1.0)
		config.set_value("settings", "window_mode", "FULLSCREEN")
		config.save(file_path)
	else:
		config.load(file_path)


func save_setting(key: String, value):
	config.set_value("settings", key, value)
	config.save(file_path)


func load_settings():
	var settings = {}
	for key in config.get_section_keys("settings"):
		settings[key] = config.get_value("settings", key)
	return settings
