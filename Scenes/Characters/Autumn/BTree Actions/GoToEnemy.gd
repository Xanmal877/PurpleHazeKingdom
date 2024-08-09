extends ActionLeaf

@export var NavAgent: NavigationAgent2D


func CanUsePhysics(_state):
	if user.target != null:
		return true
	return false



func UseActionPhysics(_state):
	time -= 0.1
	if time <= 0:
		time = 1.5
		if user.target != null:
			NavAgent.target_position = user.target
			user.direction = user.to_local(NavAgent.get_next_path_position()).normalized()
