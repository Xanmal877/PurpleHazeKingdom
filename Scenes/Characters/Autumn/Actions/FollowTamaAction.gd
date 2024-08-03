class_name FollowTama extends TaskTestTree

@onready var navagent = $"../../../navagent"

func CanUseState(_state):
	navagent.target_position = Character.tama.global_position
	if navagent.is_target_reachable():
		return Character.tama.global_position.distance_to(Character.global_position) >= 50
		#if Character.isincombat == true:
			#return false
	return false


func UseActionBasedonState(_state):
	navagent.target_position = Character.tama.global_position
	Character.direction = Character.to_local(navagent.get_next_path_position()).normalized()
	Character.velocity = Character.direction * Character.stats.speed
	Character.stats.speed = Character.stats.normalSpeed
	Character.WalkingAnim(true)
	Character.UpdateBlend()


