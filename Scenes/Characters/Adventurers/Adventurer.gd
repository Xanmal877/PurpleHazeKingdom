class_name Adventurer extends CharacterBody2D



#region Variables

var attributes: Dictionary = {

	"Strength": 12,
	"Dexterity": 10,
	"Constitution": 12,
	"Intelligence": 8,
	"Wisdom": 8,
	"Charisma": 10,
	}

var stats: Dictionary ={

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
	"spellDamage": (attributes["Intelligence"] * 10) * 0.5,}

var economy: Dictionary = {
	"Gold": 0
}

@export var NavAgent: NavigationAgent2D

#endregion


#region The Runtimes

func _physics_process(delta):
	move_and_slide()

#endregion


#region Navigation

enum {MOVE, IDLE, COMBAT, EXPLORE}
var currentState
func MakePath():
	if currentState == IDLE:
		velocity = Vector2.ZERO
		stats.speed = 0

	if currentState == MOVE or currentState == EXPLORE:
		stats.direction = to_local(NavAgent.get_next_path_position()).normalized()
		velocity = stats.direction * stats.speed
		stats.speed = stats.normalSpeed

	if currentState == COMBAT:
		velocity = Vector2.ZERO
		stats.speed = 0

#endregion


#region Combat

var enemy
func InAttackRange(body):
	print(body)
	if body.is_in_group("enemy"):
		print(enemy)
		enemy = body


func NotInAttackRange(body):
	if body.is_in_group("enemy"):
		enemy = null


func Combat():
	if enemy != null:
		enemy.stats.health -= stats.damage
		print(enemy)

#endregion


