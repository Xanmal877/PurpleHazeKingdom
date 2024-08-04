extends TaskTestTree

@onready var mana_bar = $"../../../ManaBar"

func CanUsePhysics(_state):
	# Check if enemy is close
	var enemies = get_tree().get_nodes_in_group("enemy")
	if Character.stats.mana >= 20:
		for enemy in enemies:
			if Character.global_position.distance_to(enemy.global_position) <= 60 and Character.stats.mana >= 20:
				return true
		if Character.isincombat:
			return true
	return false


func UseActionPhysics(_state):
	Character.velocity = Vector2.ZERO
	Character.stats.speed = 0
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closestenemy = null

	for enemy in enemies:
		var distance = Character.global_position.distance_to(enemy.global_position)
		if distance <= 60:
			closestenemy = enemy

	if closestenemy == null:
		Character.isincombat = false
		Character.CastVoidBoltAnim(false)

	if closestenemy != null:
		Character.target = closestenemy
		Character.CastVoidBoltAnim(true)
		Character.UpdateBlend()
		mana_bar.Status()


const VOID_BOLT = preload("res://Scenes/Tools/Weapons/Ranged/VoidBolt.tscn")

func FireVoidBolt():
	var vbolt = VOID_BOLT.instantiate()
	vbolt.user = Character
	add_child(vbolt)


