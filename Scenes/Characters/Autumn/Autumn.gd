extends CharacterBody2D


#region Variables

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")
var FollowTama: bool = false
var travelling: bool = false
var target

var deathTimer: float = 30

var attributes: Dictionary = {

	"Strength": 10,
	"Dexterity": 10,
	"Constitution": 10,
	"Intelligence": 14,
	"Wisdom": 12,
	"Charisma": 10

	}


var stats: Dictionary = {
	"name": "Autumn",
	"level": 1,
	"Class": "Void Mage",

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

	"damage": (attributes["Strength"] * 10) * 0.5,
	"normalDamage":  (attributes["Dexterity"] * 10) * 0.5,
	"sneakDamage": (attributes["Dexterity"] * 10) * 2,
	"spellDamage": (attributes["Intelligence"] * 10) * 1.5,

	"currentXP": 0,
	"requiredXP": 0,
	"overallXP": 0,
}

var economy: Dictionary = {
	"Gold": 0
}

@export var NavAgent: NavigationAgent2D
@export var RespawnMarker: Marker2D

@onready var inventory = $UI/Inventory
@onready var healthbar = $Healthbar
@onready var staminabar = $Staminabar
@onready var manabar = $ManaBar

#endregion


#region The Runtimes

func _ready():
	stats.requiredXP = (stats.level * 1.5) * 100


func _physics_process(_delta):
	move_and_slide()


func _input(event):
	if Input.is_action_just_pressed("FollowTama"):
		FollowTama = !FollowTama
	OpenInventory()



#endregion


#region Pickup Items

func FindItems(area):
	if area.is_in_group("Item"):
		var item = area.get_parent()
		NavAgent.target_position = item.global_position
		inventory.AddItemtoInventory(item.item)
		item.queue_free()

#endregion


#region Combat

const VOID_BOLT = preload("res://Scenes/Tools/Weapons/Ranged/VoidBolt.tscn")
func FireVoidBolt():
	var vbolt = VOID_BOLT.instantiate()
	vbolt.user = self
	add_child(vbolt)

func TakeDamage(body):
	if body.is_in_group("enemy"):
		var enemy = body
		stats.health -= (enemy.physicalDamage - stats.physicalDefense)

#endregion


#region Regeneration

@onready var regenerationtimer = $Timers/RegenerationTimer
func RegenerationTimeout():
	if stats.health < stats.maxHealth:
		stats.health += stats.healthRegen
	if stats.stamina < stats.maxStamina:
		stats.stamina += stats.staminaRegen
	if stats.mana < stats.maxMana:
		stats.mana += stats.manaRegen
		healthbar.Status()
		staminabar.Status()
		manabar.Status()

#endregion


#region Animation

@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree

func WalkingAnim(value: bool):
	Animation_Tree["parameters/conditions/Walking"] = value
	Animation_Tree["parameters/conditions/Idle"] = not value


var isincombat: bool
func CastVoidBoltAnim(value: bool):
	Animation_Tree["parameters/conditions/VoidBolt"] = value
	isincombat = value


func UpdateBlend():
	Animation_Tree["parameters/Idle/blend_position"] = stats.direction
	Animation_Tree["parameters/Walking/blend_position"] = stats.direction
	Animation_Tree["parameters/VoidBolt/blend_position"] = stats.direction


#endregion


#region Knockback

func Knockback(enemy, body):
	var pushback = Vector2(0, 0)
	var KnockbackTween = get_tree().create_tween()

	if stats.lastDirection == Vector2.LEFT:
		pushback.x = -10
	elif stats.lastDirection == Vector2.RIGHT:
		pushback.x = 10
	elif stats.lastDirection == Vector2.DOWN:
		pushback.y = 10
	elif stats.lastDirection == Vector2.UP:
		pushback.y = -10

	if body.is_in_group("enemy"):
		if enemy.is_inside_tree():
			KnockbackTween.tween_property(enemy, "position", enemy.position + pushback, 0.2)

#endregion


#region Select Character

@onready var inventoryui = $UI/Inventory
var mouseEntered: bool = false
func MouseOn():
		mouseEntered = true


func MouseOff():
		mouseEntered = false


func OpenInventory():
	if Input.is_action_just_pressed("Interact") and mouseEntered == true:
		inventoryui.visible = !inventoryui.visible
		currentState = IDLE

#endregion


#region Navigation

enum {MOVE, IDLE, COMBAT, EXPLORE}
var currentState
func MakePath():
	if currentState == IDLE:
		velocity = Vector2.ZERO
		stats.speed = 0
		WalkingAnim(false)
		UpdateBlend()
	if currentState == MOVE or currentState == EXPLORE:
		stats.direction = to_local(NavAgent.get_next_path_position()).normalized()
		velocity = stats.direction * stats.speed
		stats.speed = stats.normalSpeed
		WalkingAnim(true)
		UpdateBlend()
	if currentState == COMBAT:
		velocity = Vector2.ZERO
		stats.speed = 0

#endregion


#region Respawn

func Respawn():
	global_position = RespawnMarker.global_position
	currentState = IDLE
	CastVoidBoltAnim(false)
	stats.health = stats.maxHealth
	stats.stamina = stats.maxStamina
	stats.mana = stats.maxMana

#endregion


func LevelUp():
	stats.requiredXP = (stats.level * 1.5) * 100
	if stats.currentXP >= stats.requiredXP:
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
