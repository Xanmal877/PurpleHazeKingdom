class_name ItemBase extends Node2D

@onready var player: TamanekoClass
@export var item: ItemResource = ItemResource.new()


func Pickup(body):
	if body.is_in_group("player"):
		player = body as TamanekoClass
		player.inventory.AddItemtoInventory(item)
		queue_free()


