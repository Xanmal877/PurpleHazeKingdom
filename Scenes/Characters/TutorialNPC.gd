extends CharacterBody2D


@export var quest: Quest
var QuestSlimesKilled: int = 0

func _ready():
	GameManager.MonsterKilled.connect(SlimeQuestOne)

func _on_interact_area_entered(area):
	if area.is_in_group("InteractBox"):
		if quest.questStatus == quest.QuestStatus.available:
			quest.StartQuest()
		elif quest.questStatus == quest.QuestStatus.reachedGoal:
			quest.FinishQuest()
			quest.questStatus = quest.QuestStatus.available

func SlimeQuestOne(Name, XPValue, GoldValue):
	if quest.questStatus == quest.QuestStatus.started:
		QuestSlimesKilled += 1
		print("QuestSlimesKilled count: ", QuestSlimesKilled)
		if QuestSlimesKilled >= 1:
			quest.ReachedGoal()
