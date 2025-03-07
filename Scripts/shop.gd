extends Area2D

@export var shop = preload("res://Scenes/Upgrades/upgrade_shop.tscn")


func _on_area_entered(area):
	if area.is_in_group("player"):
		if shop == null:
			shop = Globals.shop_scene
		var inst = Globals.create_instance(Globals.shop_scene, Vector2.ZERO, Globals.world_controller.get_node("ShopUI"))
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
		tween.tween_callback(get_parent().queue_free)
