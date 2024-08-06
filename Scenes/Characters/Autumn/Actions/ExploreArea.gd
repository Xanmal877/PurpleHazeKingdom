extends ActionLeaf

@export var NavAgent: NavigationAgent2D


func CanUsePhysics(_state):
	if Character.stats.health >= (Character.stats.maxHealth * 0.5):
		return true
	return false


var enemy
func UseActionPhysics(_state) -> void:
	var enemies = get_tree().get_nodes_in_group("enemy")
	if !enemies.is_empty():
		if enemy == null:
			enemy = enemies.pick_random()
		elif enemy != null:
			time -= 0.1
			if time <= 0:
				time = 1
				NavAgent.target_position = enemy.global_position
				Character.stats.direction = Character.to_local(NavAgent.get_next_path_position()).normalized()
				Character.WalkingAnim(true)
				Character.UpdateBlend()
				Character.stats.speed = Character.stats.normalSpeed
				Character.velocity = Character.stats.direction * Character.stats.speed

