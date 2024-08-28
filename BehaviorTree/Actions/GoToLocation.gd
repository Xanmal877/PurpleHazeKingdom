class_name GoToLocationAction extends ActionLeaf


@export var NavAgent: NavigationAgent2D
var pointreached: bool = false

func CanUsePhysics(_state):
	if user.target != null:
		return true
	return false


func UseActionPhysics(_state):
	time -= 0.1
	if time <= 0:
		time = 1.5
		NavAgent.target_position = user.target.global_position
		user.stats.direction = user.to_local(NavAgent.get_next_path_position()).normalized()
		if NavAgent.distance_to_target() <= 30:
			user.target = null
