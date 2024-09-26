extends Control

var dogtags: Array[Control]
var gap = 30


func add_dogtag(tag: Control):
	if !dogtags.has(tag):
		tag.get_parent().remove_child(tag)
		add_child(tag)
		dogtags.append(tag)
