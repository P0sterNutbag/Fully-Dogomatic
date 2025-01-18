extends Node

var queue: Array[Array]
var enemy = preload("res://Scenes/Enemies/enemy.tscn")
var enemy_small = preload("res://Scenes/Enemies/enemy_small.tscn")
var enemy_large = preload("res://Scenes/Enemies/enemy_large.tscn")
var enemy_bomber = preload("res://Scenes/Enemies/enemy_bomber.tscn")
var enemy_indexes = {
	enemy : 0,
	enemy_small : 1,
	enemy_large : 2,
	enemy_bomber : 3,
}


#func _ready() -> void:
	#Globals.enemy_pool = self
	#queue.resize(enemy_indexes.size())
	#for i in queue.size():
		#for ii in 400:
			#var inst = enemy_indexes.find_key(i).instantiate()
			#queue[i].append(inst)


func spawn_enemy(enemy_to_spawn: PackedScene):
	var queue_index = enemy_indexes[enemy_to_spawn]
	if queue[queue_index].size() == 0:
		var inst = enemy_to_spawn.instantiate()
		inst.tree_exited.connect(queue[queue_index].append.bind(inst))
		return inst
	else:
		return queue[queue_index].pop_back()
