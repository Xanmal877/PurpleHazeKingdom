class_name FollowTama extends TaskTestTree


func CanUseState(_state):
	Character.navagent.target_position = Character.tama.global_position
	if Character.navagent.is_target_reachable():
		return Character.tama.global_position.distance_to(Character.global_position) >= 50
	return false


func UseActionBasedonState(_state):
	Character.navagent.target_position = Character.tama.global_position
	Character.direction = Character.to_local(Character.navagent.get_next_path_position()).normalized()
	Character.velocity = Character.direction * Character.stats.speed
	Character.stats.speed = Character.stats.normalSpeed
	Character.WalkingAnim(true)
	Character.UpdateBlend()


