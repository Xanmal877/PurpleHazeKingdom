class_name Quest extends QuestManager

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")

func _ready():
	GameManager.QuestDecision.connect(StartQuest)


func StartQuestText():
	QuestBox.visible = true
	QuestTitle.text = questName
	QuestDescription.text = questDescription
	QuestReward.text = "Rewards:  " + "\n" + "Gold: " + str(Gold) + "\n" + "XP: " + str(Experience)
	AcceptButton.show()
	DeclineButton.show()
	CompleteButton.hide()


func StartQuest(choice) -> void:
	if choice == true:
		if questStatus == QuestStatus.available:
			questStatus = QuestStatus.started
	elif choice == false:
		QuestTitle.text = ""
		QuestDescription.text = ""
		QuestReward.text = ""
	AcceptButton.hide()
	DeclineButton.hide()


func ReachedGoal() -> void:
	if questStatus == QuestStatus.started:
		questStatus = QuestStatus.reachedGoal
		QuestDescription.text = reachedGoalText


func FinishQuestText():
	QuestBox.visible = true
	QuestTitle.text = questName + "\n" + "Completed"
	QuestDescription.text = FinishedQuestText
	AcceptButton.hide()
	DeclineButton.hide()
	CompleteButton.show()


func FinishQuest():
	if questStatus == QuestStatus.reachedGoal:
		questStatus = QuestStatus.finished
		QuestTitle.text = ""
		QuestDescription.text = ""
		QuestReward.text = ""
		CompleteButton.hide()
		tama.stats.currentXP += Experience
		tama.stats.CheckForLevelUp()

