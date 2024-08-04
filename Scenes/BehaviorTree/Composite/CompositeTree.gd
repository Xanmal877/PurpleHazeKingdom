class_name CompositeLeaf extends TaskTestTree


func CanUsePhysics(_state):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUsePhysics(get_parent()):
				return true
	return false


func UseActionPhysics(_state):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUsePhysics(get_parent()):
				child.UseActionPhysics(get_parent())
				return

