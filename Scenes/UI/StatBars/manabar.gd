extends ProgressBar

@export var user: CharacterBody2D

signal HealthUpdate
signal StaminaUpdate
signal ManaUpdate


func _ready():
	max_value = user.maxMana
	value = user.mana


func Status():
	max_value = user.maxMana
	value = user.mana



