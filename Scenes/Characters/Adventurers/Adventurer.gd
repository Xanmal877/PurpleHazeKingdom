class_name Adventurer extends CharacterBody2D


#region Variables

var enemynear

var attributes: Dictionary = {

	"Strength": 10,
	"Dexterity": 10,
	"Constitution": 10,
	"Intelligence": 10,
	"Wisdom": 10,
	"Charisma": 10,
	}

var stats: Dictionary ={
	"name": "N/A",
	"level": 1,
	"Class": "N/A",

	"maxHealth": attributes["Constitution"] * 10,
	"maxStamina": attributes["Dexterity"] * 10,
	"maxMana": attributes["Intelligence"] * 10,

	"health": attributes["Constitution"] * 10,
	"stamina": attributes["Dexterity"] * 10,
	"mana": attributes["Intelligence"] * 10,

	"healthRegen": attributes["Constitution"] * 0.01,
	"staminaRegen": attributes["Dexterity"] * 0.5,
	"manaRegen": attributes["Wisdom"] * 0.5,

	"direction": Vector2(),
	"lastDirection": Vector2(),

	"speed": (attributes["Dexterity"] * 10) * 0.5,
	"normalSpeed": (attributes["Dexterity"] * 10) * 0.5,
	"sneakSpeed": (attributes["Dexterity"] * 10) * 0.2,
	"dashSpeed": (attributes["Dexterity"] * 10) * 5,

	"damage": (attributes["Strength"] * 10) * 0.2,
	"normalDamage":  (attributes["Strength"] * 10) * 0.2,
	"sneakDamage": (attributes["Dexterity"] * 10) * 2,
	"spellDamage": (attributes["Intelligence"] * 10) * 0.5,

	"currentXP": 0,
	"requiredXP": 0,
	"overallXP": 0,
	}

var economy: Dictionary = {
	"Gold": 0
}

@export var NavAgent: NavigationAgent2D
@export var RespawnMarker: Marker2D

@onready var animation_player = $Animations/AnimationPlayer
@onready var healthbar = $Healthbar
@onready var staminabar = $Staminabar
@onready var manabar = $Manabar


#endregion


#region The Runtimes

func _ready():
	stats.requiredXP = (stats.level * 1.5) * 100


func _physics_process(delta):
	if enemynear != null:
		stats.direction = global_position.direction_to(enemynear.global_position).normalized()
		velocity = stats.direction * stats.speed
	if stats.health <= 0:
		Respawn()
	move_and_slide()

func _input(event):
	OpenInventory()


#endregion


#region Combat


func Detected(area):
	if area.get_parent().get_parent().is_in_group("enemy"):
		enemynear = area


func NotDetected(area):
	if area.get_parent().get_parent().is_in_group("enemy"):
		enemynear = null



var enemy
func InAttackRange(body):
	if body.is_in_group("enemy"):
		enemy = body
		healthbar.visible = true
		staminabar.visible = true
		manabar.visible = true


func NotInAttackRange(body):
	if body.is_in_group("enemy"):
		enemy = null
		healthbar.visible = false
		staminabar.visible = false
		manabar.visible = false
		animation_player.stop()


func Combat():
	if enemy != null:
		animation_player.play("Attack")
		enemy.stats.health -= stats.damage
		if enemy.stats.health <= 0:
			stats.currentXP += 35
			LevelUp()


func Respawn():
	global_position = RespawnMarker.global_position
	stats.health = stats.maxHealth
	stats.stamina = stats.maxStamina
	stats.mana = stats.maxMana

#endregion


#region Select Character

@onready var inventoryui = $UI/Inventory
var mouseEntered: bool = false
func MouseEntered():
	mouseEntered = true


func MouseExited():
	mouseEntered = false


func CharacterLeftScreen():
	inventoryui.visible = false


#endregion


#region GUI Actions

func OpenInventory():
	if Input.is_action_just_pressed("Interact") and mouseEntered == true:
		inventoryui.visible = !inventoryui.visible

#endregion


#region XP

func LevelUp():
	stats.requiredXP = (stats.level * 1.5) * 100
	if stats.currentXP >= stats.requiredXP:
		print(stats.level)
		stats.level += 1
		IncreaseAttributes()
		attributes.Intelligence += 1
		attributes.Wisdom += 1


func IncreaseAttributes():
	attributes.Strength += 1
	attributes.Dexterity += 1
	attributes.Constitution += 1
	attributes.Intelligence += 1
	attributes.Wisdom += 1


#endregion






