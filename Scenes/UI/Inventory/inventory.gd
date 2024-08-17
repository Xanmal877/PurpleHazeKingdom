class_name InventoryClass extends Control

#region Variables and Signals

#region Variables

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

#endregion


#region inventory Code

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


#region HotBar Slots

#func UseHealthPotion():
	#if Input.is_action_just_pressed("Slot 1"):
		#for i in inventory.Items:
			#if i.name == "Health Potion":
				#if i.amount > 0 and health != maxHealth:
					#health += 10
					#i.amount -= 1
#
#
#func UseStaminaPotion():
	#if Input.is_action_just_pressed("Slot 2"):
		#for i in inventory.Items:
			#if i.name == "Stamina Potion":
				#if i.amount > 0:
					#stamina += 10
					#i.amount -= 1

#endregion

#
##region MoveWindows
#
#var mousepos = get_global_mouse_position()
#var moving: bool = false
#func MoveWindow():
	#if mouseEntered == true:
		#if Input.is_action_just_pressed("Left Click"):
			#moving = true
		#if Input.is_action_just_released("Left Click"):
			#moving = false
#
#
#var mouseEntered: bool = false
#
#func TitleEntered():
	#mouseEntered = true
	#print(mouseEntered)
#
#
#func TitleExited():
	#mouseEntered = false
	#print(mouseEntered)
#
#
##endregion
