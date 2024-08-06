extends Control


@onready var amount = $Slot/amount
@onready var cname = $Slot/CName
@onready var classname = $Slot/classname

var mouseEntered: bool = false


func SlotEntered():
	mouseEntered = true


func SlotExited():
	mouseEntered = false

