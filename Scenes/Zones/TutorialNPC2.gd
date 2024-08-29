extends CharacterBody2D
#
#@export var quest: Quest
#var BranchPickedup: bool = false
#
#func _ready():
	#GameManager.ItemPickedUp.connect(BranchQuest)
#
#
#func _on_interact_area_entered(area):
	#if area.is_in_group("InteractBox"):
		#if quest.questStatus == quest.QuestStatus.available:
			#quest.StartQuest()
		#elif quest.questStatus == quest.QuestStatus.reachedGoal:
			#quest.FinishQuest()
			#
#
#
#func BranchQuest(item):
	#if quest.questStatus == quest.QuestStatus.started:
		#if item.name == "Branch":
			#quest.ReachedGoal()
			#
