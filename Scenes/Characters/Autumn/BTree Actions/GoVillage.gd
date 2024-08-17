extends ActionLeaf

@export var NavAgent: NavigationAgent2D
var trick: bool = false
@onready var zone = get_tree().get_first_node_in_group("SEVillage")


func CanUsePhysics(_state):
	time += 1
	if time == 3:
		time = 0
		if user.FollowTama:
			return false
		NavAgent.target_position = zone.global_position
		if NavAgent.distance_to_target() <= 30:
			return false
		return true


func UseActionPhysics(_state):
		user.currentState = user.MOVE
		user.WalkingAnim(true)
		user.UpdateBlend()


