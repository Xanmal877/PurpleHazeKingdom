class_name FollowTama extends TaskTestTree

@onready var navagent = $"../../../navagent"

var time: int = 0


func CanUsePhysics(_state):
	navagent.target_position = Character.tama.global_position
	if navagent.is_target_reachable():
		return Character.tama.global_position.distance_to(Character.global_position) >= 50
	return false


func UseActionPhysics(_state):
	Navigate()
	Character.WalkingAnim(true)
	Character.UpdateBlend()
	if Character.tama.global_position.distance_to(Character.global_position) >= 500:
		Character.global_position = Character.tama.global_position


func Navigate():
	navagent.target_position = Character.tama.global_position
	Character.direction = Character.to_local(navagent.get_next_path_position()).normalized()
	Character.velocity = Character.direction * Character.stats.speed
	Character.stats.speed = Character.stats.normalSpeed


