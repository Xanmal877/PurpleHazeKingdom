extends CharacterBody2D


#region Variables

@onready var Tamaneko = get_tree().get_first_node_in_group("Tamaneko")

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

#endregion


#region The Runtimes

func _ready():
	currentState = IDLE
	StateMachine()

func _physics_process(_delta):
	move_and_slide()


#endregion


#region StateMachine

#region Setup Statemachine

enum {
	IDLE,
	FOLLOWTAMA,
	COMBAT,
}

var currentState
func StateMachine():
	match currentState:
		IDLE:
			Idle()
		FOLLOWTAMA:
			FollowTama()
		COMBAT:
			Combat()

#endregion


#region Idle State

var IdleTime = randf_range(1,3)

func Idle():
	await get_tree().create_timer(IdleTime).timeout
	currentState = FOLLOWTAMA
	StateMachine()


#endregion


#region Follow State

func FollowTama():
	if Tamaneko:
		navagent.target_position = Tamaneko.global_position
		if navagent.is_target_reachable():
			pass
		else:
			Idle()

#endregion

#endregion


#region Navigation

@onready var navtimer = $Timers/navtimer
@onready var navagent = $navagent
func MakePath():
	if target != null:
		currentState = COMBAT
		StateMachine()
		WalkingAnim(false)
		UpdateBlend()
		velocity = Vector2.ZERO
		stats.speed = 0
		navagent.target_position = global_position
	elif target == null:
		CombatStance(false)
		CastVoidBoltAnim(false)
		if currentState == FOLLOWTAMA and navagent.distance_to_target() >= 10 and navagent.is_target_reachable():
			print("Follow Tama")
			navagent.target_position = Tamaneko.global_position
			direction = to_local(navagent.get_next_path_position()).normalized()
			velocity = direction * stats.speed
			stats.speed = stats.normalSpeed
			WalkingAnim(true)
			UpdateBlend()
		else:
			WalkingAnim(false)
			UpdateBlend()
			navagent.target_position = global_position
			velocity = Vector2.ZERO
			stats.speed = 0
			currentState = IDLE
			StateMachine()

#endregion


#region Combat State


#region Detection

var EnemyArray: Array = []
func EnemyDetected(body):
	if body.is_in_group("enemy"):
		if !EnemyArray.has(body):
			EnemyArray.append(body)
			if currentState != COMBAT:
				currentState = COMBAT
				StateMachine()


func EnemyLost(body):
	if body.is_in_group("enemy"):
		EnemyArray.erase(body)

#endregion


#region Combat

var target
func Combat():
	currentState = COMBAT
	for enemy in EnemyArray:
		target = enemy
		if target.stats.health <= 0:
			EnemyArray.erase(enemy)
		if stats.mana >= 20:
			CombatStance(true)
			await get_tree().create_timer(2.1).timeout
			CastVoidBoltAnim(true)


const VOID_BOLT = preload("res://Scenes/Tools/Weapons/Ranged/VoidBolt.tscn")
func FireVoidBolt():
	var vbolt = VOID_BOLT.instantiate()
	vbolt.user = self
	add_child(vbolt)
	


func TakeDamage(body):
	if body.is_in_group("enemy"):
		var enemy = body
		stats.health -= (enemy.physicalDamage - stats.physicalDefense)
		Knockback(enemy, body)

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

#endregion


#region Animation

@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree

func WalkingAnim(value: bool):
	Animation_Tree["parameters/conditions/Walking"] = value
	Animation_Tree["parameters/conditions/Idle"] = not value


func CombatStance(value: bool):
	Animation_Tree["parameters/conditions/Combat"] = value


func CastVoidBoltAnim(value: bool):
	Animation_Tree["parameters/conditions/VoidBolt"] = value
	Animation_Tree["parameters/conditions/Reset"] = not value


func UpdateBlend():
	Animation_Tree["parameters/Idle/blend_position"] = direction
	Animation_Tree["parameters/Walking/blend_position"] = direction
	Animation_Tree["parameters/CombatStance/blend_position"] = direction
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

