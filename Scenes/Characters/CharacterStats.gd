class_name CharacterStats extends Resource

#region Attributes

@export_category("Basic Info")
@export var Name: String
@export var Class: String
@export var level: int

@export_category("Attributes")
@export var Strength: int
@export var Dexterity: int
@export var Perception: int
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

var Damage: float
var sneakDamage: float
var spellDamage: float

var gold: int

var direction: Vector2
var lastDirection: Vector2

var currentPosition: Vector2
var detectionRadius: float

#endregion


#region Experience and Stat System

var currentXP: float
var requiredXP: float
var overallXP: float


func CatchUpLevel():
	for i in range(level):
		StatUpdates()


func CheckForLevelUp():
	requiredXP = (level * 1.5) * 100
	if currentXP >= requiredXP:
		currentXP -= requiredXP
		currentXP += overallXP
		
		level += 1
		
	StatUpdates()



func StatUpdates():
		Strength += 1
		Dexterity += 1
		Perception += 1
		Constitution += 1
		Intelligence += 1
		Wisdom += 1
		Charisma += 1

		maxHealth = int(20 + (Constitution + Strength) / 1.2)
		maxStamina = int(20 + (Dexterity + Constitution) / 1.2)
		maxMana = int(20 + (Wisdom + Intelligence) / 1.2)

		health = maxHealth
		stamina = maxStamina
		mana = maxMana

		healthRegen = Constitution * 0.01
		staminaRegen = Dexterity * 0.1
		manaRegen = Wisdom * 0.05

		speed = int(60 + (Dexterity + Perception) / 1.2)
		sneakSpeed = 30 + Dexterity
		dashSpeed = 200 + Dexterity

		Damage = 2 + Strength
		sneakDamage = 5 + Dexterity
		spellDamage = 10 + Intelligence
		
		detectionRadius = (Perception * 10)

#endregion

