extends ActionLeaf

@export var NavAgent: NavigationAgent2D


func CanUsePhysics(_state):
	if user.target == null:
		return true
	return false



func UseActionPhysics(_state):
	time -= 0.1
	if time <= 0:
		time = 1
	var enemies = get_tree().get_nodes_in_group("enemy")
	if !enemies.is_empty():
		var enemy = enemies.pick_random()
		user.target = enemy

