class_name QuestManager extends Node2D


@onready var AcceptButton: Button = get_tree().get_first_node_in_group("QAcceptButton")
@onready var DeclineButton: Button = get_tree().get_first_node_in_group("QDeclineButton")
@onready var CompleteButton: Button = get_tree().get_first_node_in_group("QCompleteButton")
@onready var QuestBox: CanvasLayer = get_tree().get_first_node_in_group("QuestBox")
@onready var QuestTitle: Label = get_tree().get_first_node_in_group("QuestTitle")
@onready var QuestReward: Label = get_tree().get_first_node_in_group("QuestRewardText")
@onready var QuestDescription: RichTextLabel = get_tree().get_first_node_in_group("QuestDescription")


@export_group("Quest Settings")
@export var questName: String
@export_multiline var questDescription: String
@export_multiline var reachedGoalText: String
@export_multiline var FinishedQuestText: String
@export_multiline var QuestRewardText: String


enum QuestStatus {
	available,
	started,
	reachedGoal,
	finished,
}

@export var questStatus: QuestStatus = QuestStatus.available

@export_group("Rewards")
@export var Experience: int
@export var Gold: int
