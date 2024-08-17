extends ProgressBar

@export var user: CharacterBody2D


func _ready():
	max_value = user.stats.maxStamina
	value = user.stats.stamina


func Status():
	max_value = user.stats.maxStamina
	value = user.stats.stamina
