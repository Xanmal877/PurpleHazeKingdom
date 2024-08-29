class_name AutumnAttackEnemy extends ActionLeaf




func CanUsePhysics(_state):
	if user.isincombat == true:
		return true
	return false


func UseActionPhysics(_state):
	time -= 0.1
	if time <= 0:
		time = 10
		user.FireVoidBolt()

