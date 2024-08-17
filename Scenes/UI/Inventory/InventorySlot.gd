extends Control

@onready var image = $Slot/image
@onready var amount = $Slot/amount

var mouseEntered: bool = false


func SlotEntered():
	mouseEntered = true


func SlotExited():
	mouseEntered = false

