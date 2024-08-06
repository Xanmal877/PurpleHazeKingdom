extends ActionLeaf

@onready var navagent = $"../../../../TravelAgent"


func CanUseState(_state):
	return true


func UseActionBasedonState(_state):
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closestenemy = null
	for enemy in enemies:
		var distance = Character.global_position.distance_to(enemy.global_position)
		if distance <= 100:
			closestenemy = enemy
			navagent.target_position = closestenemy.global_position


