extends ProgressBar


@export var user: CharacterBody2D

func _ready():
	max_value = user.stats.maxMana
	value = user.stats.mana


func Status():
	max_value = user.stats.maxMana
	value = user.stats.mana



