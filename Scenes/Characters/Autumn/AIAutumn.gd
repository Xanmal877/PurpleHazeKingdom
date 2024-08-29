extends CharacterBody2D


#region Variables

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")
var FollowTama: bool = false
var target = null
var isincombat: bool = false
var isCasting: bool = false

@export var NavAgent: NavigationAgent2D
@export var RespawnMarker: Marker2D

@onready var inventory = $UI/Inventory
@onready var healthbar = $Statbars/VBoxContainer/Healthbar
@onready var staminabar = $Statbars/VBoxContainer/Staminabar
@onready var manabar = $Statbars/VBoxContainer/Manabar
@onready var expbar = $Statbars/VBoxContainer/expbar

@export var stats: CharacterStats

#endregion


#region The Runtimes

func _ready():
	stats.CheckForLevelUp()
	GameManagerReady()
	WalkingAnim(false)
	UpdateBlend()
	#print(
	#"Level:  " + str(stats.level) +
	#"\n" + "Strength:  " + str(stats.Strength) +
	#"\n" + "Dexterity:  " + str(stats.Dexterity) +
	#"\n" + "Perception:  " + str(stats.Perception) +
	#"\n" + "Constitution:  " + str(stats.Constitution) +
	#"\n" + "Intelligence:  " + str(stats.Intelligence)
	#)




func _physics_process(_delta):
	if target:
		if global_position.distance_to(target.global_position) <= 100:
			velocity = Vector2.ZERO
			CastVoidBoltAnim(true)
			UpdateBlend()
		elif global_position.distance_to(target.global_position) > 70:
			velocity = Vector2.ZERO
			CastVoidBoltAnim(false)
			UpdateBlend()
			await get_tree().create_timer(1).timeout
			WalkingAnim(true)
			UpdateBlend()
			velocity = stats.direction * stats.speed
	if !target:
			WalkingAnim(false)
			UpdateBlend()
			velocity = Vector2.ZERO
	move_and_slide()


func _input(event):
	if Input.is_action_just_pressed("FollowTama"):
		FollowTama = !FollowTama
	OpenInventory()


func GameManagerReady():
	GameManager.connect("AttackMade", TakeDamage)
	GameManager.connect("MonsterKilled", MonsterKilled)


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

func ScanForEnemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if global_position.distance_to(enemy.global_position) <= 100:
			target = enemy
			isincombat = true


func ScannerTimeout():
	ScanForEnemies()


func FireVoidBolt():
	var vbolt = VOID_BOLT.instantiate()
	vbolt.player = self
	vbolt.target = target
	add_sibling(vbolt)
	vbolt.global_position = self.global_position
	await get_tree().create_timer(0.5).timeout



func TakeDamage(Attacker, Attacked, Damage):
	if Attacked != self:
		return
	stats.health -= Damage
	healthbar.Status()
	staminabar.Status()
	manabar.Status()


func MonsterKilled(Killer, XPvalue, GoldValue):
	if Killer != self:
		return
	stats.currentXP += XPvalue
	stats.gold += GoldValue
	expbar.Status()
	stats.CheckForLevelUp()
	isincombat = false
	target = null


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


func CastVoidBoltAnim(value: bool):
	isCasting = not value
	Animation_Tree["parameters/conditions/VoidBolt"] = value
	Animation_Tree["parameters/conditions/Reset"] = not value


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

#endregion


#region Respawn

func Respawn():
	global_position = RespawnMarker.global_position
	stats.health = stats.maxHealth
	stats.stamina = stats.maxStamina
	stats.mana = stats.maxMana


#endregion


func LevelUp():
	stats.LevelUp()
	stats.Strength += 2
	stats.Constitution += 2
	stats.StatUpdates()

