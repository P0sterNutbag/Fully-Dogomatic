extends Node

var queue: Array[Array]
var death_explosion = preload("res://Scenes/Particles/death_explosion.tscn")
var death_explosion_large = preload("res://Scenes/Particles/death_explosion_large.tscn")
var enemy_explosion = preload("res://Scenes/Particles/enemy_explosion.tscn")
var bullet_explosion = preload("res://Scenes/Bullets/bullet_explosion.tscn")
var bullet_explosion_big = preload("res://Scenes/Bullets/bullet_explosion_big.tscn")
var explosion = preload("res://Scenes/Particles/explosion.tscn")
var indexes = {
	death_explosion : 0,
	death_explosion_large : 1,
	enemy_explosion : 2,
	bullet_explosion : 3,
	bullet_explosion_big : 4,
	explosion : 5,
}


func _ready() -> void:
	Globals.explosion_pool = self
	queue.resize(indexes.size())


func spawn_explosion(scene_to_spawn: PackedScene):
	var queue_index = indexes[scene_to_spawn]
	if queue[queue_index].size() == 0:
		var inst = scene_to_spawn.instantiate()
		inst.tree_exited.connect(queue[queue_index].append.bind(inst))
		return inst
	else:
		return queue[queue_index].pop_back()
