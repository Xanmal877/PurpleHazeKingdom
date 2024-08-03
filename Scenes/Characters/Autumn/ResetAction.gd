class_name ResetAction extends ActionLeaf



func CanUseState(_state):
	#if Character.isincombat == false:
		#return true
	return false


func UseActionBasedonState(_state):
	Character.VoidBoltAnim(false)


