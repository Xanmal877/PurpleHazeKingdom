extends ActionLeaf

@export var NavAgent: NavigationAgent2D

var trick: bool = false

func CanUsePhysics(_state):
	time += 1
	if time == 2:
		time = 0
		if user.FollowTama == true:
			NavAgent.target_position = user.tama.global_position
			return user.tama.global_position.distance_to(user.global_position) >= 20
	return false


func UseActionPhysics(_state):
	user.currentState = user.MOVE
	if user.tama.global_position.distance_to(user.global_position) >= 500:
		user.global_position = user.tama.global_position
		user.UpdateBlend()
