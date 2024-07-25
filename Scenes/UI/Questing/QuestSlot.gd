extends Control

@export var Quest: MissionResource
@onready var quest_title = $"Slot/Quest Title"
@onready var description = $Slot/Description
@onready var goals = $Slot/Goals
@onready var player = get_tree().get_first_node_in_group("player")


func _ready():
	quest_title.text = Quest.QuestName
	description.text = Quest.QuestDescription
	goals.text = str(Quest.requirements.name) + "\n" + str(Quest.requirements.amount) + "/" + str(player.inventory.Items)

 
