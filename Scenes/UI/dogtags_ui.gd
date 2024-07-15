extends Control

var dogtags: Array[Control]
var gap = 30

func add_dogtag(tag: Control):
	if !dogtags.has(tag):
		var pos = tag.global_position
		tag.get_parent().remove_child(tag)
		add_child(tag)
		tag.global_position = pos
		dogtags.append(tag)
		for i in range(dogtags.size()):
			dogtags[i].target_position = Vector2(global_position.x - i * gap, global_position.y)
			print_debug(global_position)
