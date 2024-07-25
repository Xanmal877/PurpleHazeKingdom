class_name QuestLog extends Control


@onready var inventory_grid = $InventoryGrid
@onready var player = get_tree().get_first_node_in_group("player")
const QUEST_SLOT = preload("res://Scenes/UI/Questing/QuestSlot.tscn")

func _physics_process(_delta):
	QuestUpdate()


func QuestUpdate():
	for child in inventory_grid.get_children():
		inventory_grid.remove_child(child)
		child.queue_free()

	for item in player.inventory:
		var slot = QUEST_SLOT.instantiate()
		inventory_grid.add_child(slot)
		#slot.image.texture = item.image
		slot.amount.text = str(item.amount)
		slot.image.texture_normal = item.image


