extends GameStats


#region Variables and Signals

#region Variables

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")
var FollowTama: bool = false
var target = null
var isincombat: bool


var economy: Dictionary = {
	"Gold": 0
}

@export var NavAgent: NavigationAgent2D
@export var RespawnMarker: Marker2D

@onready var inventory = $UI/Inventory
@onready var statbars = $Statbars

#endregion


#region Signals

signal AnimChange(Anim)

#endregion

#endregion


#region The Runtimes

func _ready():
	requiredXP = (level * 1.5) * 100
	GameManager.MonsterKilled.connect(LevelUp)


func _physics_process(_delta):
	if isincombat == true:
		velocity = Vector2.ZERO
		speed = 0
		WalkingAnim(false)
		UpdateBlend()
	else:
		CastVoidBoltAnim(false)
		UpdateBlend()
		WalkingAnim(true)
		UpdateBlend()
		speed = normalSpeed
		velocity = direction * speed
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

func EnemyDetected(area):
	if area.is_in_group("enemyDetectbox"):
		target = area.get_owner()
		NavAgent.target_position = target.global_position


func EnemyNotDetected(area):
	if area.is_in_group("enemyDetectbox"):
		target = null


const VOID_BOLT = preload("res://Scenes/Tools/Weapons/Ranged/VoidBolt.tscn")
func FireVoidBolt():
	var vbolt = VOID_BOLT.instantiate()
	vbolt.user = self
	add_child(vbolt)



func InDamageRange(area):
	pass


func NotInDamageRange(area):
	if area.is_in_group("enemy"):
		pass


func TakeDamage(area):
	if area.is_in_group("enemy"):
		statbars.Status()


#endregion


#region Regeneration

@onready var regenerationtimer = $Timers/RegenerationTimer
func RegenerationTimeout():
	if health < maxHealth:
		health += healthRegen
	if stamina < maxStamina:
		stamina += staminaRegen
	if mana < maxMana:
		mana += manaRegen
		statbars.Status()

#endregion


#region Animation

@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree

func WalkingAnim(value: bool):
	Animation_Tree["parameters/conditions/Walking"] = value
	Animation_Tree["parameters/conditions/Idle"] = not value


func CastVoidBoltAnim(value: bool):
	Animation_Tree["parameters/conditions/VoidBolt"] = value
	Animation_Tree["parameters/conditions/Reset"] = not value


func UpdateBlend():
	Animation_Tree["parameters/Idle/blend_position"] = direction
	Animation_Tree["parameters/Walking/blend_position"] = direction
	Animation_Tree["parameters/VoidBolt/blend_position"] = direction


#endregion


#region Knockback

func Knockback(enemy, body):
	var pushback = Vector2(0, 0)
	var KnockbackTween = get_tree().create_tween()

	if lastDirection == Vector2.LEFT:
		pushback.x = -10
	elif lastDirection == Vector2.RIGHT:
		pushback.x = 10
	elif lastDirection == Vector2.DOWN:
		pushback.y = 10
	elif lastDirection == Vector2.UP:
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
	CastVoidBoltAnim(false)
	health = maxHealth
	stamina = maxStamina
	mana = maxMana

#endregion


func LevelUp(Killer, XPvalue, GoldValue):
	super.LevelUp(Killer, XPvalue, GoldValue)
	Strength += 2
	Constitution += 2
	StatUpdates()
