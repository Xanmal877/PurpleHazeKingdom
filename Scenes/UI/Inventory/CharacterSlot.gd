extends Control


@onready var adventurer_info = $Slot/AdventurerInfo


var mouseEntered: bool = false


func SlotEntered():
	mouseEntered = true


func SlotExited():
	mouseEntered = false

