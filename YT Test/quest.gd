class_name Quest extends QuestManager

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")

func StartQuest() -> void:
	if questStatus == QuestStatus.available:
		questStatus = QuestStatus.started
		QuestBox.visible = true
		QuestTitle.text = questName
		QuestDescription.text = questDescription + " Reward: " + "\n"+ " XP "  + str(Experience)


func ReachedGoal() -> void:
	if questStatus == QuestStatus.started:
		questStatus = QuestStatus.reachedGoal
		QuestDescription.text = reachedGoalText


func FinishQuest():
	if questStatus == QuestStatus.reachedGoal:
		questStatus = QuestStatus.finished
		QuestBox.visible = false
		tama.stats.currentXP += Experience
		tama.stats.CheckForLevelUp()

