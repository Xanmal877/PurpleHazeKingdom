class_name QuestManager extends Node2D


@onready var QuestBox: CanvasLayer = get_tree().get_first_node_in_group("QuestBox")
@onready var QuestTitle: RichTextLabel = get_tree().get_first_node_in_group("QuestTitle")
@onready var QuestDescription: RichTextLabel = get_tree().get_first_node_in_group("QuestDescription")

@export_group("Quest Settings")
@export var questName: String
@export var questDescription: String
@export var reachedGoalText: String


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
