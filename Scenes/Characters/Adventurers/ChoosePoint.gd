extends ActionLeaf

@export var NavAgent: NavigationAgent2D
@onready var Locations = get_tree().get_nodes_in_group("GuardMarker")


func CanUsePhysics(_state):
	if user.target == null:
		return true
	return false


func UseActionPhysics(_state):
	user.target = Locations.pick_random()
	if NavAgent.distance_to_target() >= 50:
		NavAgent.target_position = user.target.global_position

