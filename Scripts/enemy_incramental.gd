extends Enemy
class_name EnemyIncramental


@export var health_multiplier: float = 1.0
var health: int:
	set(value):
		health = value * health_multiplier
		$Hurtbox.health = health
		$Hurtbox.max_health = health
