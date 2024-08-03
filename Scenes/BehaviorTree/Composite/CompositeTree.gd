class_name CompositeLeaf extends TaskTestTree


func CanUseState(_state):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUseState(get_parent()):
				return true
	return false


func UseActionBasedonState(_state):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUseState(get_parent()):
				child.UseActionBasedonState(get_parent())
				return

