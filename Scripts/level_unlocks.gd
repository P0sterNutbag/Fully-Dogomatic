extends Resource
class_name LevelUnlocks

@export var unlocks_array: Array[String]
var names = {
	"character1": "coda",
	"character2": "toaster",
	"character3": "esquire",
	"character4": "boogy",
}
var pics = {
	"character1": load("res://Art/Sprites/dachsund portrait.png"),
	"character2": load("res://Art/Sprites/cat portrait.png"),
	"character3": load("res://Art/Sprites/terrier portrait.png"),
	"character4": load("res://Art/Sprites/bulldog portrait.png"),
}


func unlock(last_level: int, current_level: int) -> int:
	var levels_unlocked = 0
	if last_level == current_level:
		return 0
	for i in range(last_level, current_level):
		SaveData.set(unlocks_array[i+1], true)
		levels_unlocked += 1
	SaveData.save_game()
	return levels_unlocked
