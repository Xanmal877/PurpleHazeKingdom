class_name FindSlimes extends ActionLeaf


func CanUsePhysics(_state):
	if user.target == null:
		return true
	return false


func UseActionPhysics(_state):
	time -= 0.1
	if time <= 0:
		time = 30
		var slimes = get_tree().get_nodes_in_group("Slime")
		var nearest_slime = null
		var min_distance = INF  # Start with a large value

		for slime in slimes:
			var distance = user.global_position.distance_to(slime.global_position)
			if distance < min_distance:
				min_distance = distance
				nearest_slime = slime

		if nearest_slime:
			user.target = nearest_slime
			print("Nearest slime found at distance: ", min_distance)

