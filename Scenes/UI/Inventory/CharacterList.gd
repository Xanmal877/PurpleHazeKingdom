extends Control

#region Variables and Signals

#region Variables

@onready var player = get_tree().get_first_node_in_group("Tamaneko")

@onready var title = $VBoxContainer/Inventory/Title
@onready var grid = $VBoxContainer/Inventory/ScrollContainer/Grid

const CHARACTER_SLOT = preload("res://Scenes/UI/Inventory/CharacterSlot.tscn")


#endregion


#region Signals

signal AddItem(item: ItemResource)
signal RemoveItem(item: ItemResource)

#endregion

#endregion


#region The Runtimes

func _ready():
	title.text = "Character List"

func _input(event):
	OpenCList()

#endregion


func ClistUpdate():
	var Characters = get_tree().get_nodes_in_group("Adventurer")
	var puppy: Array = Characters
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	for adv in puppy:
		var slot = CHARACTER_SLOT.instantiate()
		grid.add_child(slot)
		
		slot.adventurer_info.text = str(adv.stats.Name) + "\n" + "Level:  " + str(adv.stats.level) + "\n" + str(adv.stats.Class)


func OpenCList():
	if Input.is_action_just_pressed("Character List"):
		visible = !visible
		ClistUpdate()


func _on_timer_timeout():
	ClistUpdate()
