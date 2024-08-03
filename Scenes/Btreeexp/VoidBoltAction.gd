class_name VoidBoltAction extends TaskTestTree



func CanUseState(_state):
	if Character.stats.mana >= 20:
		return true
	return false


func UseActionBasedonState(_state):
	Character.CastVoidBoltAnim(true)


