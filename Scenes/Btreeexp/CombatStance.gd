class_name CombatStanceAction extends TaskTestTree


func CanUseState(_state):
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if Character.global_position.distance_to(enemy.global_position) <= 80:
			return true
	if Character.isincombat == true:
		return true
	return false


func UseActionBasedonState(_state):
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closestenemy
	var closestdistance:float = -1
	for enemy in enemies:
		if (closestdistance == -1 and Character.global_position.distance_to(enemy.global_position) <= 60) \
			or (Character.global_position.distance_to(enemy.global_position) < closestdistance):
				closestenemy = enemy
				closestdistance = Character.global_position.distance_to(enemy.global_position)
	if closestenemy != null:
		Character.target = closestenemy
		if Character.isincombat == false:
			Character.CombatStance(true)
			await get_tree().create_timer(2.1).timeout
		var children = get_children()
		for child in children:
			if child is TaskTestTree:
				if child.CanUseState(get_parent()):
					child.UseActionBasedonState(get_parent())
					return
	else:
		Character.CastVoidBoltAnim(false)
		Character.CombatStance(false)
		

#endregion


