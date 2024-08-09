extends ActionLeaf


@export var NavAgent: NavigationAgent2D
var pointreached: bool = false

func CanUsePhysics(_state):
	if user.target != null and NavAgent.distance_to_target() >= 30:
		return true
	return false


func UseActionPhysics(_state):
	time -= 0.1
	if time <= 0:
		time = 1.5
		user.direction = user.to_local(NavAgent.get_next_path_position()).normalized()
		#if NavAgent.distance_to_target() <= 30:
			#user.target = null
		#if user.global_position.distance_to(user.target) <= 30:
			#user.target = null
