extends Panel

@export var user: CharacterBody2D

@onready var healthbar = $Healthbar
@onready var staminabar = $Staminabar
@onready var manabar = $Manabar


func _ready():
	healthbar.max_value = user.maxHealth
	healthbar.value = user.health
	staminabar.max_value = user.maxStamina
	staminabar.value = user.stamina
	manabar.max_value = user.maxMana
	manabar.value = user.mana



func Status():
	healthbar.max_value = user.maxHealth
	healthbar.value = user.health
	staminabar.max_value = user.maxStamina
	staminabar.value = user.stamina
	manabar.max_value = user.maxMana
	manabar.value = user.mana
