class_name ItemBase extends Node2D

#region Variables

var player
var ally
var inrange: bool = false
@onready var inrangelabel = $inrangelabel

@export var item: ItemResource = ItemResource.new()
signal ItemPickedup

#endregion


func _input(_event):
	PickupItem()


func AreaEntered(area):
	if area.is_in_group("InteractBox"):
		player = area.get_parent().get_parent()
		inrange = true
		inrangelabel.visible = true


func AreaExited(area):
	if area.is_in_group("InteractBox"):
		player = null
		inrange = false
		inrangelabel.visible = false


func PickupItem():
	if Input.is_action_just_pressed("Interact") and inrange == true:
		player.inventory.AddItemtoInventory(item)
		queue_free()
		ItemPickedup.emit()

