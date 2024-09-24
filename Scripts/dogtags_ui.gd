extends Control

var dogtags: Array[Control]
var gap = 30


func add_dogtag(tag: Control):
	if !dogtags.has(tag):
		var pos = tag.global_position
		tag.get_parent().remove_child(tag)
		add_child(tag)
		#tag.global_position = pos
		dogtags.append(tag)
		#	print_debug(global_position)
