extends ActionLeaf


@onready var statbars = $"../../../Statbars"


func CanUsePhysics(_state):
	if user.target != null \
	and user.global_position.distance_to(user.target.global_position) <= 100:
		user.CastVoidBoltAnim(true)
		user.UpdateBlend()
		return true
	if user.target == null \
	or user.mana < 20 \
	or user.global_position.distance_to(user.target.global_position) >= 100:
		user.CastVoidBoltAnim(false)
		user.UpdateBlend()
		return false
	return false


func UseActionPhysics(_state):
	user.isincombat = true
	time -= 0.1
	if time <= 0:
		time = 5
		user.CastVoidBoltAnim(true)
		user.UpdateBlend()
		if user.target.health <= 0:
			user.currentXP += 35
			user.target = null
		if user.target == null or user.mana < 20:
			user.CastVoidBoltAnim(false)
			user.UpdateBlend()
			await user.Animation_Tree.animation_finished
			user.isincombat = false


const VOID_BOLT = preload("res://Scenes/Tools/Weapons/Ranged/VoidBolt.tscn")
func FireVoidBolt():
	var vbolt = VOID_BOLT.instantiate()
	vbolt.user = user
	add_child(vbolt)
	user.mana -= 20
	statbars.Status()
	user.UpdateBlend()
