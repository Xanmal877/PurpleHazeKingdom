extends ActionLeaf

@export var NavAgent: NavigationAgent2D

var current_target = null

func CanUsePhysics(_state):
	if Character.stats.health >= (Character.stats.maxHealth * 0.5):
		return true
	return false


func UseActionPhysics(_state):
	if not current_target:
		var enemies = get_tree().get_nodes_in_group("enemy")
		if enemies.size() > 0:
			current_target = enemies[randi() % enemies.size()]
			NavAgent.target_position = current_target.global_position
			Character.currentState = Character.MOVE
	else:
		if not current_target.is_inside_tree():
			current_target = null
			var enemies = get_tree().get_nodes_in_group("enemy")
			var closest_enemy = null
			var min_distance = INF
			
			for enemy in enemies:
				var distance = Character.global_position.distance_to(enemy.global_position)
				if distance < min_distance:
					min_distance = distance
					closest_enemy = enemy
			
			if closest_enemy:
				current_target = closest_enemy
				NavAgent.target_position = current_target.global_position
				Character.currentState = Character.MOVE
			else:
				Character.currentState = Character.EXPLORE
		else:
			NavAgent.target_position = current_target.global_position
			Character.currentState = Character.MOVE

