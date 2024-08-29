class_name InventoryClass extends Control

#region Variables and Signals

#region Variables

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")

var Items: Array[ItemResource]

@export var user: CharacterBody2D
@onready var inventory = $"."
@onready var namelabel = $VBoxContainer/Inventory/Panel/namelabel
@onready var grid = $VBoxContainer/Inventory/ScrollContainer/Grid

const INVENTORY_SLOT = preload("res://Scenes/UI/Inventory/InventorySlot.tscn")

#endregion


#region Signals

signal AddItem(item: ItemResource)
signal RemoveItem(item: ItemResource)

#endregion

#endregion


#region The Runtimes

func _ready():
	await get_tree().create_timer(1).timeout
	namelabel.text = user.stats.Name


func _input(event):
	OpenInventory()


#endregion


#region inventory Code

func OpenInventory():
	if Input.is_action_just_pressed("Inventory"):
		visible = !visible
		if visible:
			tama.inmenu = true
		else:
			tama.inmenu = false

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

#endregion

