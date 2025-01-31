extends Node

const file_path = "user://savedata.sav"
var character0 = true
var character1 = false
var character2 = false
var character3 = false
var character4 = false
var c0_win = false
var c1_win = false
var c2_win = false
var c3_win = false
var c4_win = false
var best_time = 0.0


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
		"best_time" : best_time,
		"c0_win" : c0_win,
		"c1_win" : c1_win,
		"c2_win" : c2_win,
		"c3_win" : c3_win,
		"c4_win" : c4_win,
	}
	var json_string = JSON.stringify(dict)
	save_file.store_line(json_string)


func load_game():
	if not FileAccess.file_exists(file_path):
		save_game()
	var save_file = FileAccess.open(file_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.data
		for i in node_data:
			set(i, node_data[i])
