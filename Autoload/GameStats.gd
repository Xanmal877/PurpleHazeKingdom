class_name GameStats extends CharacterBody2D


var direction: Vector2
var lastDirection: Vector2


#regionAttributes

@export_category("Attributes")
@export var Strength: int  = 10
@export var Dexterity: int  = 10
@export var Constitution: int  = 10
@export var Intelligence: int  = 10
@export var Wisdom: int  = 10
@export var Charisma: int  = 10

#endregion


#region Stats

@export_category("Stats")
@export var Name: String = ""
@export var Class: String = ""
@export var level: int = 1

var maxHealth: float = Constitution * 10
var maxStamina: float = Dexterity * 10
var maxMana: float = Intelligence * 10

var health: float = maxHealth
var stamina: float = maxStamina
var mana: float = maxMana

var healthRegen: float = Constitution * 0.1
var staminaRegen: float = Dexterity * 0.5
var manaRegen: float = Wisdom * 0.5

var speed: float = (Dexterity * 10) * 0.3
var normalSpeed: float = (Dexterity * 10) * 0.3
var sneakSpeed: float = (Dexterity * 10) * 0.2
var dashSpeed: float = (Dexterity * 10) * 5

var damage: float = (Strength * 10) * 0.2
var normalDamage: float = (Strength * 10) * 0.2
var sneakDamage: float = (Dexterity * 10) * 2
var spellDamage: float = (Intelligence * 10) * 0.5

var gold: int = 0

#endregion


#region XP

var currentXP: float = 0
var requiredXP: float = 0
var overallXP: float = 0


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
	maxHealth = Constitution * 10
	maxStamina = Dexterity * 10
	maxMana = Intelligence * 10

	health = maxHealth
	stamina = maxStamina
	mana = maxMana

	healthRegen = Constitution * 0.1
	staminaRegen = Dexterity * 0.5
	manaRegen = Wisdom * 0.5

	speed = (Dexterity * 10) * 0.5
	normalSpeed = (Dexterity * 10) * 0.5
	sneakSpeed = (Dexterity * 10) * 0.2
	dashSpeed = (Dexterity * 10) * 5

	damage = (Strength * 10) * 0.2
	normalDamage = (Strength * 10) * 0.2
	sneakDamage = (Dexterity * 10) * 2
	spellDamage = (Intelligence * 10) * 0.5




#endregion


@onready var adventurerNames: Array = [
	"Thalia Moonshadow",
	"Jareth Stormblade",
	"Elara Windrider",
	"Kael Fireheart",
	"Lyra Nightingale",
	"Dorian Swiftstrike",
	"Seraphina Emberforge",
	"Roderick Frostbeard",
	"Aric Blackwood",
	"Isolde Starfall",
	"Tamsin Duskbringer",
	"Garrick Ironfist",
	"Vespera Thundertide",
	"Cedric Ravenshade",
	"Marisol Seabreeze",
	"Thorne Darkhunter",
	"Elowen Silverleaf",
	"Orion Dawncaller",
	"Nyssa Shadowstep",
	"Evander Stormchaser"
]


@onready var guardNames: Array = [
	"Harven Steelclad",
	"Alistair Greyshield",
	"Lira Windblade",
	"Bran Stonehelm",
	"Thorne Ironfist",
	"Celia Brightsword",
	"Garret Frostblade",
	"Thalia Shadowguard",
	"Roderick Ironoak",
	"Elara Quickstrike",
	"Jaxon Darksteel",
	"Mira Stormwatch",
	"Orin Wolfheart",
	"Sera Lightbringer",
	"Darius Stormclad",
	"Kael Thunderstrike",
	"Vira Emberblade",
	"Torin Swiftwind",
	"Lyra Sunshield",
	"Drake Ironclaw"
]

