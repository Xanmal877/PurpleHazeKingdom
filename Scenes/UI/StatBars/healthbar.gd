extends ProgressBar

@export var user: CharacterBody2D

func _ready():
	max_value = user.stats.maxHealth
	value = user.stats.health


func Status():
	max_value = user.stats.maxHealth
	value = user.stats.health
