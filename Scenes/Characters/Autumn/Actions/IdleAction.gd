extends TaskTestTree

var IdleTime = randf_range(1,3)

func CanUsePhysics(_state):
	if Character.isincombat == true:
		return false
	return true


func UseActionPhysics(_state):
	Character.WalkingAnim(false)
	Character.UpdateBlend()
	Character.navagent.target_position = Character.global_position
	Character.velocity = Vector2.ZERO
	Character.stats.speed = 0
