extends Resource
class_name LevelUnlocks

@export var unlocks_array: Array[String]


func unlock(current_level: int) -> void:
	for i in unlocks_array.size():
		if i > current_level:
			SaveData.save_game()
			return
		SaveData.set(unlocks_array[i], true)
	SaveData.save_game()
