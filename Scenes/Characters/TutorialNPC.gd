extends CharacterBody2D

var inarea
@export var quest: Quest
var QuestSlimesKilled: int = 0


func _ready():
	GameManager.MonsterKilled.connect(SlimeQuestOne)
	GameManager.QuestCompleted.connect(FinishQuest)


func _input(event):
	Questie()


func Questie():
	if Input.is_action_just_pressed("Interact") and inarea == true:
		if quest.questStatus == quest.QuestStatus.available:
			quest.StartQuestText()
		elif quest.questStatus == quest.QuestStatus.reachedGoal:
			quest.FinishQuestText()


func FinishQuest():
	if inarea == true:
		quest.FinishQuest()


func _on_interact_area_entered(area):
	if area.is_in_group("InteractBox"):
		inarea = true


func _on_interact_area_exited(area):
	if area.is_in_group("InteractBox"):
		inarea = false


func SlimeQuestOne(Killer, XPValue, GoldValue):
	var tama = get_tree().get_first_node_in_group("Tamaneko")
	if Killer == tama:
		if quest.questStatus == quest.QuestStatus.started:
			QuestSlimesKilled += 1
			print("QuestSlimesKilled count: ", QuestSlimesKilled)
			if QuestSlimesKilled >= 1:
				quest.ReachedGoal()



