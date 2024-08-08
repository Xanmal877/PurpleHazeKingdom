class_name ResetAction extends ActionLeaf



func CanUseState(_state):
	#if user.isincombat == false:
		#return true
	return false


func UseActionBasedonState(_state):
	user.VoidBoltAnim(false)


