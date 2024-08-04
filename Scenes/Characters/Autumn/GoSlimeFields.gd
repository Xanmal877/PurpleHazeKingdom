extends ActionLeaf


@onready var navagent = $"../../../navagent"

func _ready():
	pass


func CanUseState(_state):
	var zone = get_tree().get_first_node_in_group("SFields")
	if Character.stats.health >= Character.stats.maxHealth \
	and Character.stats.stamina >= Character.stats.maxStamina \
	and Character.stats.mana >= Character.stats.maxMana:
		return true
	if Character.global_position.distance_to(zone.global_position) <= 80:
		return false
	return false


func UseActionBasedonState(_state):
	var zone = get_tree().get_first_node_in_group("SFields")
	navagent.target_position = zone.global_position
	Character.direction = Character.to_local(navagent.get_next_path_position()).normalized()
	Character.velocity = Character.direction * Character.stats.speed
	Character.stats.speed = Character.stats.normalSpeed
	Character.WalkingAnim(true)
	Character.UpdateBlend()
	#if navagent.distance_to_target() <= 50:
		#var spots = zone.get_children()
		#spots.shuffle()
		#var chosenspot = spots.pop_back()
		#navagent.target_position = chosenspot.global_position



