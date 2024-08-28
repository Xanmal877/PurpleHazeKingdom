class_name FindLocationAction extends ActionLeaf


@export var NavAgent: NavigationAgent2D
@onready var Locations = get_tree().get_nodes_in_group("PossibleLocation")

func CanUsePhysics(_state):
	if user.target == null:
		return true
	return false


func UseActionPhysics(_state):
	user.target = Locations.pick_random()

