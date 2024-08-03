class_name IdleAction extends TaskTestTree

var IdleTime = randf_range(1,3)

func CanUseState(_state):
	return true


func UseActionBasedonState(_state):
	#await get_tree().create_timer(IdleTime).timeout
	Character.WalkingAnim(false)
	Character.UpdateBlend()
	Character.navagent.target_position = Character.global_position
	Character.velocity = Vector2.ZERO
	Character.stats.speed = 0
