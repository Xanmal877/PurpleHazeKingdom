extends ActionLeaf


@onready var navagent = $"../../../navagent"

func CanUseState(_state):
	if user.health <= user.maxHealth / 2 \
	or user.stamina <= user.maxStamina / 2 \
	or user.mana <= user.maxMana / 2:
		return true
	return false


func UseActionBasedonState(_state):
	var zone = get_tree().get_first_node_in_group("SEVillage")
	navagent.target_position = zone.global_position
	user.direction = user.to_local(navagent.get_next_path_position()).normalized()
	user.velocity = user.direction * user.speed
	user.speed = user.normalSpeed
	user.WalkingAnim(true)
	user.UpdateBlend()


