extends Control

#region Variables and Signals

#region Variables

@onready var Characters = get_tree().get_nodes_in_group("Adventurer")

@export var player: CharacterBody2D

@onready var inventory_owner = $VBoxContainer/InventoryOwner
@onready var grid = $VBoxContainer/Inventory/Grid


const CHARACTER_SLOT = preload("res://Scenes/UI/Inventory/CharacterSlot.tscn")


#endregion


#region Signals

signal AddItem(item: ItemResource)
signal RemoveItem(item: ItemResource)

#endregion

#endregion


#region The Runtimes

func _ready():
	inventory_owner.text = "Character List"

func _process(delta):
	ClistUpdate()

#endregion


func ClistUpdate():
	var puppy: Array = Characters
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	for adv in puppy:
		var slot = CHARACTER_SLOT.instantiate()
		grid.add_child(slot)
		
		slot.cname.text = str(adv.stats.name)
		slot.amount.text = str(adv.stats.level)
		slot.classname.text = str(adv.stats.Class)


#func AddItemtoInventory(item: ItemResource):
	#var index = Items.find(item)
	#if index != -1:
		#item.amount += 1
		#AddItem.emit(item)
		#InventoryUpdate()
	#else:
		#Items.append(item)
		#AddItem.emit(item)
		#InventoryUpdate()
#
#
#func RemoveItemFromInventory(item: ItemResource):
	#Items.erase(item)
	#RemoveItem.emit(item)
	#InventoryUpdate()
#
#
#func GetItem(itemname: String):
	#for i in Items:
		#if i.name == itemname:
			#return i
		#else:
			#return 0
	#return null

