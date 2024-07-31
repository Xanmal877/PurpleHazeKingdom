class_name ItemBase extends Node2D

#region Variables

var player
var inrange: bool = false
@onready var inrangelabel = $inrangelabel

@export var item: ItemResource = ItemResource.new()
signal ItemPickedup

#endregion

#
#func _input(_event):
	#PickupItem()


func BodyEntered(body):
	if body.is_in_group("player"):
		player = body
		inrange = true
		print(player, inrange)
		player.inventory.AddItemtoInventory(item)
		queue_free()
		ItemPickedup.emit()

