extends Node

var queue: Array[Array]
var bullet = preload("res://Scenes/Bullets/regular_bullet.tscn")
var grenade = preload("res://Scenes/Bullets/grenade.tscn")
var rocket = preload("res://Scenes/Bullets/rocket.tscn")
var rubber_bullet = preload("res://Scenes/Bullets/rubber_bullet.tscn")
var tennis_ball = preload("res://Scenes/Bullets/tennis_ball.tscn")
var sawblade = preload("res://Scenes/Bullets/sawblade.tscn")
var bullet_indexes = {
	bullet : 0,
	grenade : 1,
	rocket : 2,
	rubber_bullet : 3,
	tennis_ball : 4,
	sawblade : 5,
}


func _ready() -> void:
	Globals.bullet_pool = self
	queue.resize(bullet_indexes.size())
	for i in queue.size():
		for ii in 100:
			var inst = bullet_indexes.find_key(i).instantiate()
			queue[i].append(inst)

func spawn_bullet(bullet_to_spawn: PackedScene):
	var queue_index = bullet_indexes[bullet_to_spawn]
	if queue[queue_index].size() == 0:
		var inst = bullet_to_spawn.instantiate()
		inst.tree_exited.connect(queue[queue_index].append.bind(inst))
		return inst
	else:
		return queue[queue_index].pop_back()
