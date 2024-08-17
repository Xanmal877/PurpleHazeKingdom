class_name QuestBase extends Panel

@export var Quest: MissionResource

@onready var title = $VBoxContainer/Title
@onready var quest_description = $VBoxContainer/QuestDescription

signal QuestAccepted

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	title.text = Quest.QuestName
	quest_description = Quest.QuestDescription
	


func _on_accept_pressed():
	QuestAccepted.emit()
	player.quest_log.AddQuesttoQuestLog(Quest)
	queue_free()


func _on_decline_pressed():
	visible = false



