extends ActionLeaf


func CanUseState(_state):
	return true


func UseActionBasedonState(_state):
	Character.navagent.target_position = Character.global_position
	Character.velocity = Vector2.ZERO
	Character.stats.speed = 0
