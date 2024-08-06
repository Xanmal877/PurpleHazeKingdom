extends ActionLeaf

@onready var mana_bar = $"../../../ManaBar"
var trick: bool = false
var closestenemy = null

func CanUsePhysics(_state):
	# Check if enemy is close
	var enemies = get_tree().get_nodes_in_group("enemy")
	if Character.stats.mana < 20:
		Character.isincombat = false
		Character.CastVoidBoltAnim(false)
		trick = false
		return false
	for enemy in enemies:
		if Character.global_position.distance_to(enemy.global_position) <= 60 and Character.stats.mana >= 20:
			return true
	if Character.isincombat:
		return true
	return false


func UseActionPhysics(_state):
	Character.velocity = Vector2.ZERO
	Character.stats.speed = 0
	if trick == false:
		trick = true
		Character.currentState = Character.COMBAT
		var enemies = get_tree().get_nodes_in_group("enemy")
		closestenemy = null
		for enemy in enemies:
			var distance = Character.global_position.distance_to(enemy.global_position)
			if distance <= 100:
				closestenemy = enemy
				Character.CastVoidBoltAnim(true)
				Character.UpdateBlend()

		if closestenemy != null:
			Character.target = closestenemy


	if closestenemy == null:
		Character.isincombat = false
		Character.CastVoidBoltAnim(false)
		trick = false


const VOID_BOLT = preload("res://Scenes/Tools/Weapons/Ranged/VoidBolt.tscn")

func FireVoidBolt():
	var vbolt = VOID_BOLT.instantiate()
	vbolt.user = Character
	add_child(vbolt)
	Character.stats.mana -= 20
	mana_bar.Status()

