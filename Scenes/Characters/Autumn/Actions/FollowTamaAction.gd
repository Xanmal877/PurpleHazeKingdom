extends ActionLeaf

@export var NavAgent: NavigationAgent2D

var trick: bool = false

func CanUsePhysics(_state):
	time += 1
	if time == 2:
		time = 0
		if Character.FollowTama == true:
			NavAgent.target_position = Character.tama.global_position
			return Character.tama.global_position.distance_to(Character.global_position) >= 20
	return false


func UseActionPhysics(_state):
	Character.currentState = Character.MOVE
	if Character.tama.global_position.distance_to(Character.global_position) >= 500:
		Character.global_position = Character.tama.global_position

