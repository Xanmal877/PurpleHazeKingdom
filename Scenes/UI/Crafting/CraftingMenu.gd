extends Panel


@onready var player = get_tree().get_first_node_in_group("player")
@onready var inventory = $".."

const HEALTH_POTION = preload("res://Scenes/Tools/Items/Potions/HealthPotion.tscn")
const STAMINA_POTION = preload("res://Scenes/Tools/Items/Potions/StaminaPotion.tscn")

func HealthPotionPressed():
	var inventory = inventory.Items
	for i in inventory:
		if i.name == "Slime Goo":
			if i.amount >= 2:
				i.amount -= 2
				var hpotion = HEALTH_POTION.instantiate()
				add_child(hpotion)
				hpotion.global_position = player.global_position


func StaminaPotionPressed():
	var inventory = inventory.Items
	for i in inventory:
		if i.name == "Slime Goo":
			if i.amount >= 2:
				i.amount -= 2
				var potion = STAMINA_POTION.instantiate()
				add_child(potion)
				potion.global_position = player.global_position
