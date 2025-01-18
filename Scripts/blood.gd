extends Sprite2D

var fade = false 


func _process(delta):
	if fade:
		modulate.a -= delta
		if modulate.a <= 0:
			queue_free()


func _on_timer_timeout():
	fade = true
