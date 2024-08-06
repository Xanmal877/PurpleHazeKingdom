extends ActionLeaf

@onready var travel_agent = $"../../../TravelAgent"
var trick: bool = false
@onready var zone = get_tree().get_first_node_in_group("TForest")



func CanUsePhysics(_state):
	return false
	time += 1
	if time == 3:
		time = 0
		if Character.FollowTama == false or Character.currentState == Character.Move:
			travel_agent.target_position = zone.global_position
			if travel_agent.distance_to_target() >= 50 and travel_agent.is_target_reachable():
				return true



func UseActionPhysics(_state):
	time += 1
	if time == 3:
		time = 0
	Character.currentState = Character.MOVE
	if travel_agent.distance_to_target() <= 40:
		pass




