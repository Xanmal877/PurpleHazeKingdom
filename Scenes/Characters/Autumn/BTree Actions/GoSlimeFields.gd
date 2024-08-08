extends ActionLeaf


@onready var navagent = $"../../../navagent"

func _ready():
	pass


func CanUseState(_state):
	var zone = get_tree().get_first_node_in_group("SFields")
	if user.health >= user.maxHealth \
	and user.stamina >= user.maxStamina \
	and user.mana >= user.maxMana:
		return true
	if user.global_position.distance_to(zone.global_position) <= 80:
		return false
	return false


func UseActionBasedonState(_state):
	var zone = get_tree().get_first_node_in_group("SFields")
	navagent.target_position = zone.global_position
	user.direction = user.to_local(navagent.get_next_path_position()).normalized()
	user.velocity = user.direction * user.speed
	user.speed = user.normalSpeed
	user.WalkingAnim(true)
	user.UpdateBlend()
	#if navagent.distance_to_target() <= 50:
		#var spots = zone.get_children()
		#spots.shuffle()
		#var chosenspot = spots.pop_back()
		#navagent.target_position = chosenspot.global_position



