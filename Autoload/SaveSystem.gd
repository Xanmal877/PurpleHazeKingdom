class_name SaveSystem extends Node

@onready var npcs = get_tree().get_nodes_in_group("NPC")

func SaveGame(user):
	var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)

	# Save player data
	var SaveData = {
		"Strength": user.stats.Strength,
		"Dexterity": user.stats.Dexterity,
		"Perception": user.stats.Perception,
		"Constitution": user.stats.Constitution,
		"Intelligence": user.stats.Intelligence,
		"Wisdom": user.stats.Wisdom,
		"Charisma": user.stats.Charisma,
		"health": user.stats.health,
		"maxHealth": user.stats.maxHealth,
		"stamina": user.stats.stamina,
		"maxStamina": user.stats.maxStamina,
		"mana": user.stats.mana,
		"maxMana": user.stats.maxMana,
		"level": user.stats.level,
		"Damage": user.stats.Damage,
		"sneakDamage": user.stats.sneakDamage,
		"spellDamage": user.stats.spellDamage,
		"speed": user.stats.speed,
		"normalSpeed": user.stats.normalSpeed,
		"sneakSpeed": user.stats.sneakSpeed,
		"dashSpeed": user.stats.dashSpeed,
		"currentXP": user.stats.currentXP,
		"requiredXP": user.stats.requiredXP,
		"overallXP": user.stats.overallXP,
		"direction": {"x": user.stats.direction.x, "y": user.stats.direction.y},
		"currentPosition": {"x": user.global_position.x, "y": user.global_position.y}
	}

	SaveData["npcs"] = []
	npcs = Engine.get_main_loop().get_nodes_in_group("NPC")
	for npc in npcs:
		var npc_data = {
			"name": npc.name,
			"position": {"x": npc.global_position.x, "y": npc.global_position.y}
		}
		SaveData["npcs"].append(npc_data)
	
	var json = JSON.stringify(SaveData)
	file.store_string(json)
	file.close()


func LoadGame(user):
	var file = FileAccess.open("user://savegame.data", FileAccess.READ)
	
	# Read the JSON string from the file
	var json = file.get_as_text()
	file.close()
	var SaveData = JSON.parse_string(json)

	# Restore the saved data to the user's stats
	user.stats.Strength = SaveData["Strength"]
	user.stats.Dexterity = SaveData["Dexterity"]
	user.stats.Perception = SaveData["Perception"]
	user.stats.Constitution = SaveData["Constitution"]
	user.stats.Intelligence = SaveData["Intelligence"]
	user.stats.Wisdom = SaveData["Wisdom"]
	user.stats.Charisma = SaveData["Charisma"]
	user.stats.health = SaveData["health"]
	user.stats.maxHealth = SaveData["maxHealth"]
	user.stats.stamina = SaveData["stamina"]
	user.stats.maxStamina = SaveData["maxStamina"]
	user.stats.mana = SaveData["mana"]
	user.stats.maxMana = SaveData["maxMana"]
	user.stats.Damage = SaveData["Damage"]
	user.stats.sneakDamage = SaveData["sneakDamage"]
	user.stats.spellDamage = SaveData["spellDamage"]
	user.stats.speed = SaveData["speed"]
	user.stats.normalSpeed = SaveData["normalSpeed"]
	user.stats.sneakSpeed = SaveData["sneakSpeed"]
	user.stats.dashSpeed = SaveData["dashSpeed"]
	user.stats.level = SaveData["level"]
	user.stats.currentXP = SaveData["currentXP"]
	user.stats.requiredXP = SaveData["requiredXP"]
	user.stats.overallXP = SaveData["overallXP"]
	user.stats.direction = Vector2(SaveData["direction"]["x"], SaveData["direction"]["y"])
	user.global_position = Vector2(SaveData["currentPosition"]["x"], SaveData["currentPosition"]["y"])

	# Restore NPC positions
	npcs = Engine.get_main_loop().get_nodes_in_group("NPC")
	for i in range(SaveData["npcs"].size()):
		var npc_data = SaveData["npcs"][i]
		var npc = npcs[i]
		npc.global_position = Vector2(npc_data["position"]["x"], npc_data["position"]["y"])
