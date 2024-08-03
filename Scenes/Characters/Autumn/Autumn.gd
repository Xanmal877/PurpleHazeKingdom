extends CharacterBody2D


#region Variables

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")
var target

var attributes: Dictionary = {
	"Strength": 10,"Dexterity": 10,
	"Constitution": 10,"Intelligence": 14,
	"Wisdom": 10,"Charisma": 10
	}


var stats: Dictionary = {
	"maxHealth": attributes.Constitution,"maxStamina": attributes.Dexterity * 10,"maxMana": attributes.Intelligence * 10,
	"health": attributes.Constitution * 10,"stamina": attributes.Dexterity * 10,"mana": attributes.Intelligence * 10,
	"healthRegen": 5,"staminaRegen": 5,"manaRegen": 10,"direction": Vector2(),"lastDirection": Vector2(),
	"speed": 30,"normalSpeed": 30,"sneakSpeed": 40,"dashSpeed": 50,
	"damage": 20,"normalDamage": 20,"sneakDamage": 20 * 4,
	}

var direction
var lastDirection

@onready var inventory = $UI/Inventory
@onready var navagent = $navagent

@onready var healthbar = $UI/HBoxContainer/Bars/Healthbar
@onready var staminabar = $UI/HBoxContainer/Bars/Staminabar


#endregion


#region The Runtimes

func _ready():
	pass

func _physics_process(_delta):
	move_and_slide()


#endregion


#region Pickup Items

func FindItems(area):
	if area.is_in_group("Item"):
		var item = area.get_parent()
		navagent.target_position = item.global_position
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
	Animation_Tree["parameters/Idle/blend_position"] = direction
	Animation_Tree["parameters/Walking/blend_position"] = direction
	Animation_Tree["parameters/VoidBolt/blend_position"] = direction


#endregion


#region Other

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

