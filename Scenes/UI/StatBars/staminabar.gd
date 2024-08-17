extends ProgressBar

@export var user: CharacterBody2D


func _ready():
	max_value = user.maxStamina
	value = user.stamina


func Status():
	max_value = user.maxStamina
	value = user.stamina
