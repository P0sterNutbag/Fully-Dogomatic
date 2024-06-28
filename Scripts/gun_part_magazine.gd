extends GunPart

@export_subgroup("Properties")
@export var rounds: int = 8
@export var reload_time: float = 1

var gun_parent


func set_gun_stats():
	gun_parent = get_parent().get_parent().get_parent().get_parent()
	if gun_parent is Gun:
		gun_parent.rounds = rounds
		gun_parent.reload_time = reload_time
		gun_parent.get_node("ReloadTimer").wait_time = reload_time
		gun_parent.shots_left = gun_parent.rounds
