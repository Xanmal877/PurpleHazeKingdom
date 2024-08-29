extends Panel

@export var user: CharacterBody2D

@onready var healthbar = $Healthbar
@onready var staminabar = $Staminabar
@onready var manabar = $Manabar


func _ready():
	healthbar.max_value = user.stats.maxHealth
	healthbar.value = user.stats.health
	staminabar.max_value = user.stats.maxStamina
	staminabar.value = user.stats.stamina
	manabar.max_value = user.stats.maxMana
	manabar.value = user.stats.mana



func Status():
	healthbar.max_value = user.stats.maxHealth
	healthbar.value = user.stats.health
	staminabar.max_value = user.stats.maxStamina
	staminabar.value = user.stats.stamina
	manabar.max_value = user.stats.maxMana
	manabar.value = user.stats.mana
