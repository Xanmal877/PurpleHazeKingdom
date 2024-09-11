extends CharacterBody2D

#
#var QSetup := QuestSetup
#var QuestSlimesKilled: int = 0
#
#
#func _ready():
	#GameManager.MonsterKilled.connect(SlimeQuestOne)
#
#
#func InteractAreaEntered(area):
	#if area.is_in_group("InteractBox"):
		#QSetup.inarea = true
#
#
#func InteractAreaExited(area):
	#if area.is_in_group("InteractBox"):
		#QSetup.inarea = false
#
#
#func SlimeQuestOne(Killer, XPValue, GoldValue):
	#var tama = get_tree().get_first_node_in_group("Tamaneko")
	#if Killer == tama:
		#if quest.questStatus == quest.QuestStatus.started:
			#QuestSlimesKilled += 1
			#print("QuestSlimesKilled count: ", QuestSlimesKilled)
			#if QuestSlimesKilled >= 1:
				#quest.ReachedGoal()


