extends ActionLeaf

var IdleTime = randf_range(1,3)
@export var NavAgent: NavigationAgent2D

func CanUsePhysics(_state):
	if Character.isincombat == true:
		return false
	if Character.stats.health == Character.stats.maxHealth :
		return false
	return true


func UseActionPhysics(_state):
	Character.currentState = Character.IDLE
	NavAgent.target_position = Character.global_position
