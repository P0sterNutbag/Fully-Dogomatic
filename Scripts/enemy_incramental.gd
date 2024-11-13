extends Enemy

@export var health_multiplier: float = 1.0
var health: int:
	set(value):
		health = value * health_multiplier
		$Hurtbox.health = health


func _ready() -> void:
	super._ready()


func on_death(bullet_direction: float = 0) -> void:
	if randf_range(0, 1) <= Globals.player.money_drop_rate:
		for i in randi_range(money_min, money_max):
			var d = Globals.create_instance(dollar, global_position)
			d.direction = bullet_direction + deg_to_rad(randf_range(-25, 25))
	Globals.create_instance(blood, $Shadow.global_position)
	Globals.world_controller.total_kills += 1
	Globals.world_controller.level_controller.enemies.erase(self)
