class_name BuildingClass extends StaticBody2D


@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Tamaneko")

func _input(event):
	OpenMenu()


var mouseEntered: bool = false
func MouseOn():
	mouseEntered = true
	print(mouseEntered)


func MouseOff():
	mouseEntered = false
	print(mouseEntered)


func OpenMenu():
	pass
