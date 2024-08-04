extends ActionLeaf


@onready var navagent = $"../../../navagent"

func CanUseState(_state):
	if Character.stats.health <= Character.stats.maxHealth / 2 \
	or Character.stats.stamina <= Character.stats.maxStamina / 2 \
	or Character.stats.mana <= Character.stats.maxMana / 2:
		return true
	return false


func UseActionBasedonState(_state):
	var zone = get_tree().get_first_node_in_group("SEVillage")
	navagent.target_position = zone.global_position
	Character.direction = Character.to_local(navagent.get_next_path_position()).normalized()
	Character.velocity = Character.direction * Character.stats.speed
	Character.stats.speed = Character.stats.normalSpeed
	Character.WalkingAnim(true)
	Character.UpdateBlend()


