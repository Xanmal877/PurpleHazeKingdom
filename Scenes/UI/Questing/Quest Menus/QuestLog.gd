class_name QuestLog extends Control

@onready var grid = $Grid
@onready var player = get_tree().get_first_node_in_group("player")
const QUEST_SLOT = preload("res://Scenes/UI/Questing/Quest Menus/QuestSlot.tscn")

var Quests: Array[MissionResource] = []

signal AddQuest(quest: MissionResource)
signal RemoveQuest(quest: MissionResource)

func QuestUpdate():
	for child in grid.get_children():
		grid.remove_child(child)
		child.queue_free()

	for quest in Quests:
		var slot = QUEST_SLOT.instantiate()
		grid.add_child(slot)
		
		slot.title.text = quest.QuestName
		slot.description.text = quest.QuestDescription
		
		var item = player.inventory.GetItem("Slime Goo")
		var item_amount = item.amount if item != null else 0
		slot.goals.text = str(quest.requirements.name) + "\n" + str(item_amount) +  "/" + str(quest.qty)



func AddQuesttoQuestLog(quest: MissionResource):
	var index = Quests.find(quest)
	if index != -1:
		quest.qty += 1
		AddQuest.emit(quest)
		QuestUpdate()
	else:
		Quests.append(quest)
		AddQuest.emit(quest)
		QuestUpdate()


func RemoveQuestFromQuestLog(quest: MissionResource):
	Quests.erase(quest)
	RemoveQuest.emit(quest)
	QuestUpdate()


func _on_timer_timeout():
	QuestUpdate()
