extends CanvasLayer

# Reference to the material you want to apply to the UI elements
@export var ui_material: Material

func _ready():
	# Call the method to apply the material to all UI elements
	apply_material_to_ui(self)

# Recursive function to apply the material to all UI elements
func apply_material_to_ui(node):
	# Iterate through each child node
	for child_index in range(node.get_child_count()):
		var child = node.get_child(child_index)

		# Check if the child node is a Control or other UI element
		if child is Node2D:
			# Apply the shader material to the UI element
			child.material = ui_material

		# Recursively apply the material to child nodes
		apply_material_to_ui(child)
