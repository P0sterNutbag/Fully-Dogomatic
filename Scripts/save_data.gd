extends Node

const file_path = "user://savedata.save"
var character0 = true
var character1 = false
var character2 = false
var character3 = false
var character4 = false
var stage0 = true
var stage1 = false
var stage2 = false
var stage0time = ""
var stage1time = ""
var stage2time = ""
var level = 0
var xp = 0


func _ready() -> void:
	load_game()


func save_game():
	var save_file = FileAccess.open(file_path, FileAccess.WRITE)
	var dict = {
		"character0" : character0,
		"character1" : character1,
		"character2" : character2,
		"character3" : character3,
		"character4" : character4,
		"stage0" : stage0,
		"stage1" : stage1,
		"stage2" : stage2,
		"stage0time" : stage0time,
		"stage1time" : stage1time,
		"stage2time" : stage2time,
		"level" : level,
		"xp" : xp
	}
	var json_string = JSON.stringify(dict)
	save_file.store_line(json_string)


func load_game():
	if not FileAccess.file_exists(file_path):
		return # Error! We don't have a save to load.
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.data
		for i in node_data:
			set(i, node_data[i])
