extends ProgressBar

@export var user: CharacterBody2D

func _ready():
	max_value = user.stats.requiredXP
	value = user.stats.currentXP


func Status():
	max_value = user.stats.requiredXP
	value = user.stats.currentXP
