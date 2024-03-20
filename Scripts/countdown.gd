extends Node2D

var minutes = 10
var seconds = 0

signal end_game

func _on_timer_timeout():
	seconds -= 1
	if seconds < 0:
		minutes -= 1
		seconds = 59
	$Minutes.text = "[right]" + str(minutes)
	$Seconds.text = str(seconds)
	if minutes < 0:
		end_game.emit()
		$Timer.stop()
