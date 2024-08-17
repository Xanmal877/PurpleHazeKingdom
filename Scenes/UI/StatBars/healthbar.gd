extends ProgressBar

@export var user: CharacterBody2D

func _ready():
	max_value = user.maxHealth
	value = user.health


func Status():
	max_value = user.maxHealth
	value = user.health
