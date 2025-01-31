extends AnimatedSprite2D

var velocity: Vector2
var grav = 10
signal reached_ground


func _process(delta: float) -> void:
	if velocity == Vector2.ZERO:
		return
	velocity.y += grav * delta
	position += velocity
	if position.y >= 0:
		velocity = Vector2.ZERO
		position = Vector2.ZERO
		reached_ground.emit()
