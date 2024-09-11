class_name QuestSetup extends CharacterBody2D


@export var quest: Quest
var inarea


func _ready():
	pass


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






