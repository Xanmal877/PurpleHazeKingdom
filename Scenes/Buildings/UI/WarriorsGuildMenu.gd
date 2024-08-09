extends BuildingMenu


const WARRIOR = preload("res://Scenes/Characters/Adventurers/Warrior.tscn")



func HireWarriorButton():
	var npc = WARRIOR.instantiate()
	adventurers.add_child(npc)
	npc.global_position = (player.global_position + Vector2(0,20))
