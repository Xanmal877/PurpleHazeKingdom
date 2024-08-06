class_name InventoryClass extends Control

var Items: Array[ItemResource]

@export var player: CharacterBody2D

@onready var inventory_owner = $VBoxContainer/InventoryOwner
@onready var economy_label = $VBoxContainer/Inventory/EconomyLabel
@onready var grid = $VBoxContainer/Inventory/Grid



const SLOT = preload("res://Scenes/UI/Inventory/Slot.tscn")

signal AddItem(item: ItemResource)
signal RemoveItem(item: ItemResource)

func _ready():
	inventory_owner.text = player.name

func _process(delta):
	economy_label.text = "Gold: " + str(player.economy.Gold)

func InventoryUpdate():
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	for item in Items:
		var slot = SLOT.instantiate()
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


func visibility():
	if visible:
		get_tree().paused = true
	else:
		get_tree().paused = false

