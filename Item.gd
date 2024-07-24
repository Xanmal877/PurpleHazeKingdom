class_name ItemBase extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@export var item: ItemResource = ItemResource.new()


func Pickup(_body):
	var inventory = player.inventory
	var found = false
	for i in range(inventory.size()):
		if inventory[i].name == item.name:
			inventory[i].amount += 1
			found = true
			break
	if not found:
		inventory.append(item)
	queue_free()


