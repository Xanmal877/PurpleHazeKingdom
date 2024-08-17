class_name CompositeLeaf extends TaskTestTree


func CanUsePhysics(_state):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			var CanUse = await child.CanUsePhysics(get_parent())
			if CanUse:
				return true
	return false


func UseActionPhysics(_state):
	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUsePhysics(get_parent()):
				child.UseActionPhysics(get_parent())
				return

