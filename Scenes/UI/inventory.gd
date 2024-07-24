class_name Inventory extends Control


@onready var inventory_grid = $InventoryGrid
@onready var player = get_tree().get_first_node_in_group("player")
var SLOT = preload("res://Scenes/UI/Slot.tscn")


func _physics_process(_delta):
	InventoryUpdate()


func InventoryUpdate():
	for child in inventory_grid.get_children():
		inventory_grid.remove_child(child)
		child.queue_free()

	for item in player.inventory:
		var slot = SLOT.instantiate()
		inventory_grid.add_child(slot)
		#slot.image.texture = item.image
		slot.amount.text = str(item.amount)
		slot.image.texture_normal = item.image


