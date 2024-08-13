extends ActionLeaf

@export var NavAgent: NavigationAgent2D
@onready var items = get_tree().get_nodes_in_group("Item")


func CanUsePhysics(_state):
	items = get_tree().get_nodes_in_group("Item")
	if !items.is_empty():
		for item in items:
			if user.global_position.distance_to(item.global_position) <= 100:
				return true
	return false


var t2 = 3
func UseActionPhysics(_state):
	time -= 0.1
	if time <= 0:
		time = 1
	if !items.is_empty():
		user.target = items.pick_random()
		NavAgent.target_position = user.target.global_position


