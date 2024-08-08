extends BuildingClass

const WARRIORS_GUILD_MENU = preload("res://Scenes/Buildings/UI/WarriorsGuildMenu.tscn")


func OpenMenu():
	if mouseEntered == true:
		if Input.is_action_just_pressed("Left Click"):
			var menu = WARRIORS_GUILD_MENU.instantiate()
			player.ui.add_child(menu)
			
