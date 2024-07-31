extends Control

#@export var Quest: MissionResource
@onready var title = $"Slot/VBoxContainer/Quest Title"
@onready var description = $Slot/VBoxContainer/Description
@onready var goals = $Slot/VBoxContainer/Goals
@onready var player = get_tree().get_first_node_in_group("player")


#func _ready():
	#title.text = Quest.QuestName
	#description.text = Quest.QuestDescription
	#goals.text = str(Quest.requirements.name) + "\n" + str(Quest.requirements.amount) + "/" + str(player.inventory.Items)

 

