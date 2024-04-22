extends Node2D

@export var slot_texture: Texture
@export var slot_texture_selected: Texture
var upgrade_texture = preload("res://Sprites/upgrade mark.png")
var gun_slots: int
var selected_index = -1


func _ready():
	gun_slots = Globals.player.gun_slots
	Globals.ui_guns = self


func _draw():
	pass
	# for i in gun_slots:
	# 	var x = position.x + 20 * i
	# 	var y = position.y
	# 	#if i >= gun_slots/2: 
	# 		#x = position.x + 20 * (i -gun_slots/2)
	# 		#y = position.y + 20
	# 	var pos = Vector2(x, y)
	# 	if i == selected_index:
	# 		draw_texture(slot_texture_selected, pos)
	# 	else:
	# 		draw_texture(slot_texture, pos)
	# 	if i < Globals.player.guns.size():
	# 		draw_texture(Globals.player.guns[i].get_meta("icon"), pos)
	# 		for ii in Globals.player.guns[i].upgrades:
	# 			draw_texture(upgrade_texture, pos + Vector2(-1 + (ii * 4), -1))


func _process(_delta):
	pass


func _on_player_gun_pickup():
	queue_redraw()


func _on_gun_selected(index_change):
	var gun_amount = Globals.player.guns.size()-1
	selected_index += index_change
	if selected_index < 0:
		selected_index = gun_amount
	elif selected_index > gun_amount:
		selected_index = 0
	queue_redraw()


func _on_upgrade_assigned():
	selected_index = -1
	queue_redraw()
