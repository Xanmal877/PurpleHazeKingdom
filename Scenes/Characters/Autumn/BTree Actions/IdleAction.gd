extends ActionLeaf

var IdleTime = randf_range(1,3)
@export var NavAgent: NavigationAgent2D

func CanUsePhysics(_state):
	if user.isincombat == true:
		return false
	if user.health == user.maxHealth :
		return false
	return true


func UseActionPhysics(_state):
	user.currentState = user.IDLE
	NavAgent.target_position = user.global_position
