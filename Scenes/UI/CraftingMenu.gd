extends Panel


@export var player: CharacterBody2D

const HEALTH_POTION = preload("res://Scenes/Tools/Items/Potions/HealthPotion.tscn")
const STAMINA_POTION = preload("res://Scenes/Tools/Items/Potions/StaminaPotion.tscn")

func HealthPotionPressed():
	var inventory = player.inventory
	print(player.inventory)
	for i in inventory:
		if i.name == "Slime Goo":
			if i.amount >= 2:
				i.amount -= 2
				var hpotion = HEALTH_POTION.instantiate()
				add_child(hpotion)
				hpotion.global_position = player.global_position


