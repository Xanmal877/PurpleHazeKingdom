class_name ItemBase extends Node2D

var player
@export var item: ItemResource = ItemResource.new()
signal ItemPickedup

func Pickup(body):
	if body.is_in_group("player"):
		player = body
		player.inventory.AddItemtoInventory(item)
		queue_free()
		ItemPickedup.emit()

