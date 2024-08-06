class_name InventoryClass extends Control

#region Variables and Signals

#region Variables

var Items: Array[ItemResource]

@export var player: CharacterBody2D

@onready var inventory_owner = $VBoxContainer/InventoryOwner
@onready var grid = $VBoxContainer/Inventory/Grid

const INVENTORY_SLOT = preload("res://Scenes/UI/Inventory/InventorySlot.tscn")

#endregion


#region Signals

signal AddItem(item: ItemResource)
signal RemoveItem(item: ItemResource)

#endregion

#endregion


#region The Runtimes

func _ready():
	inventory_owner.text = player.name

#endregion


func InventoryUpdate():
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	for item in Items:
		var slot = INVENTORY_SLOT.instantiate()
		grid.add_child(slot)

		slot.amount.text = str(item.amount)
		slot.image.texture_normal = item.image

func AddItemtoInventory(item: ItemResource):
	var index = Items.find(item)
	if index != -1:
		item.amount += 1
		AddItem.emit(item)
		InventoryUpdate()
	else:
		Items.append(item)
		AddItem.emit(item)
		InventoryUpdate()


func RemoveItemFromInventory(item: ItemResource):
	Items.erase(item)
	RemoveItem.emit(item)
	InventoryUpdate()


func GetItem(itemname: String):
	for i in Items:
		if i.name == itemname:
			return i
		else:
			return 0
	return null


func MoveItem():
	pass

