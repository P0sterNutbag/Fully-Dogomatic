extends GunUpgrade
class_name GunAttachment

@export var node_to_attach_to: String
var last_gun


func _process(delta: float) -> void:
	super._process(delta)
	if closest_gun != last_gun:
		add_part_to_gun(closest_gun)
		if last_gun != null:
			remove_part_from_gun(last_gun)
	last_gun = closest_gun


func add_part_to_gun(gun: Node2D):
	get_parent().remove_child(self)
	gun.sprite.get_node(node_to_attach_to).add_child(self)
	position = Vector2.ZERO
	rotation_degrees = 0
	$Part.visible = true


func remove_part_from_gun(gun: Node2D):
	for child in gun.sprite.get_node(node_to_attach_to).get_children():
		remove_child(child)


func add_upgrade_to_gun(gun_to_change: Node2D):
	super.add_upgrade_to_gun(gun_to_change)
	var sprite = Sprite2D.new()
	sprite.texture = $Part.texture
	sprite.region_enabled = true
	sprite.region_rect = $Part.region_rect
	sprite.offset = $Part.offset
	sprite.use_parent_material = true
	gun_to_change.sprite.get_node(node_to_attach_to).add_child(sprite)
