class_name CompositeRandomizerLeaf extends TaskTestTree

var activeChild: TaskTestTree = null

func _ready():
	var children = get_children()
	children.shuffle()


func CanUsePhysics(_state):
	if activeChild:
		return activeChild.CanUsePhysics(get_parent())

	var children = get_children()
	for child in children:
		if child is TaskTestTree:
			if child.CanUsePhysics(get_parent()):
				return true
	return false


func UseActionPhysics(_state):
	if activeChild:
		if activeChild.CanUsePhysics(get_parent()):
			activeChild.UseActionPhysics(get_parent())
			return
		else:
			activeChild = null

	var children = get_children()
	var validChildren = []

	for child in children:
		if child is TaskTestTree:
			if child.CanUsePhysics(get_parent()):
				validChildren.append(child)

	if validChildren.size() > 0:
		activeChild = validChildren[randi() % validChildren.size()]
		activeChild.UseActionPhysics(get_parent())
