class_name CharacterStats extends Resource

#region Attributes

@export_category("Basic Info")
@export var Name: String
@export var Class: String
@export var level: int

@export_category("Attributes")
@export var Strength: int
@export var Dexterity: int
@export var Constitution: int
@export var Intelligence: int
@export var Wisdom: int
@export var Charisma: int

#endregion


#region Stats

var maxHealth: float
var maxStamina: float
var maxMana: float

var health: float
var stamina: float
var mana: float

var healthRegen: float
var staminaRegen: float
var manaRegen: float

var speed: float
var normalSpeed: float
var sneakSpeed: float
var dashSpeed: float

var damage: float
var normalDamage: float
var sneakDamage: float
var spellDamage: float

var gold: int

var direction: Vector2
var lastDirection: Vector2

var currentPosition: Vector2

#endregion


#region XP

var currentXP: float
var requiredXP: float
var overallXP: float

func LevelUp(Killer, XPvalue, GoldValue):
	if Killer == self:
		currentXP += XPvalue
		gold += GoldValue
	requiredXP = (level * 1.5) * 100
	if currentXP >= requiredXP:
		level += 1
		currentXP += overallXP
		currentXP = 0
		Strength += 1
		Dexterity += 1
		Constitution += 1
		Intelligence += 1
		Wisdom += 1


func StatUpdates():
	requiredXP = (level * 1.5) * 100
	
	maxHealth = Constitution * 10
	maxStamina = Dexterity * 10
	maxMana = Intelligence * 10

	health = maxHealth
	stamina = maxStamina
	mana = maxMana

	healthRegen = Constitution * 0.01
	staminaRegen = Dexterity * 0.1
	manaRegen = Wisdom * 0.05

	speed = (Dexterity * 10) * 0.5
	normalSpeed = (Dexterity * 10) * 0.5
	sneakSpeed = (Dexterity * 10) * 0.2
	dashSpeed = (Dexterity * 10) * 5

	damage = (Strength * 10) * 0.2
	normalDamage = (Strength * 10) * 0.2
	sneakDamage = (Dexterity * 10) * 2
	spellDamage = (Intelligence * 10) * 0.5

#endregion

