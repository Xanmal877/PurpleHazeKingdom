extends CharacterBody2D


#region Variables

@onready var Tamaneko = get_tree().get_first_node_in_group("Tamaneko")

var attributes: Dictionary = {
	"Strength": 10,"Dexterity": 10,
	"Constitution": 100,"Intelligence": 10,
	"Wisdom": 10,"Charisma": 10
	}


var stats: Dictionary = {
	"health": 100,"stamina": 60,"mana": 200,"maxHealth": 100,"maxStamina": 60,"maxMana": 200,
	"healthRegen": 5,"staminaRegen": 5,"manaRegen": 10,
	"direction": Vector2(),"lastDirection": Vector2(),
	"speed": 60,"normalSpeed": 60,"sneakSpeed": 40,"dashSpeed": 600,
	"damage": 20,"normalDamage": 20,"sneakDamage": 20 * 4,}

var direction
var lastDirection

#endregion


#region The Runtimes

func _ready():
	currentState = IDLE
	StateMachine()


func _process(_delta):
	UpdateBlend()

func _physics_process(_delta):
	FollowTama()
	move_and_slide()
	if currentState == COMBAT:
		velocity = Vector2.ZERO
	if currentState != COMBAT:
		CastVoidBoltAnim(false)

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
			#print("Idle")
			Idle()
		FOLLOWTAMA:
			FollowTama()
		COMBAT:
			print("Combat")
			Combat()

#endregion


#region Idle State

var IdleTime = randf_range(0.5,3)

func Idle():
	await get_tree().create_timer(IdleTime).timeout
	currentState = FOLLOWTAMA
	followTama = true
	StateMachine()

#endregion


#region Follow State

var followTama: bool = false

func FollowTama():
	if Tamaneko and followTama == true:
		if global_position.distance_to(Tamaneko.global_position) <= 100:
			navagent.target_position = Tamaneko.global_position
		elif global_position.distance_to(Tamaneko.global_position) >= 300:
			global_position = Tamaneko.global_position
		else:
			navagent.target_position = global_position.direction_to(Tamaneko.global_position)

#endregion


#region Combat State

@onready var weaponcooldowntimer = $Timers/WeaponCooldownTimer

#region Detection

var EnemyArray: Array = []
func EnemyDetected(body):
	if body.is_in_group("enemy"):
		if !EnemyArray.has(body):
			EnemyArray.append(body)
			if currentState != COMBAT:
				currentState = COMBAT
				CombatStance(true)
				StateMachine()


func EnemyLost(body):
	if body.is_in_group("enemy"):
		EnemyArray.erase(body)
		if EnemyArray.size() == 0:
			currentState = IDLE
			stats.speed = stats.normalSpeed
			CombatStance(false)
			CastVoidBoltAnim(false)
			await get_tree().create_timer(1).timeout
			StateMachine()

#endregion


#region Combat

var enemytarget
func Combat():
	for enemy in EnemyArray:
		if enemy != null:
			enemytarget = enemy
			navagent.target_position = enemytarget.global_position
			var enemyDistance = global_position.distance_to(enemytarget.global_position)
			if enemytarget.stats.health <= 0:
				EnemyArray.erase(enemytarget)
				enemytarget.queue_free()
				StateMachine()
				break
			if enemyDistance >= 20 and stats.mana >= 20:
				CastVoidBoltAnim(true)
				UpdateBlend()
				break
			elif enemyDistance < 20:
				SwingVoidPunch()
				UpdateBlend()
				break
	if enemytarget == null:
		EnemyArray.erase(enemytarget)
		CastVoidBoltAnim(false)
		currentState = IDLE


func SwingVoidPunch():
	var enemyDistance = global_position.distance_to(enemytarget.global_position)
	if enemyDistance < 30:
		enemytarget.stats.health -= stats.spellDamage
		#CastVoidPunchAnim(false)
		currentState = IDLE


const VOID_BOLT = preload("res://Scenes/Tools/Weapons/Ranged/VoidBolt.tscn")
func FireVoidBolt():
	for enemy in EnemyArray:
		if enemy != null and stats.mana >= 20:
			var vbolt = VOID_BOLT.instantiate()
			add_child(vbolt)
			vbolt.global_position = global_position
			var enemydirection = (enemytarget.global_position - global_position).normalized()
			vbolt.velocity = enemydirection * vbolt.speed
			stats.mana -= 20
			break


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

#endregion


#region Navigation

@onready var navtimer = $Timers/navtimer
@onready var navagent = $navagent
func MakePath():
	match  currentState:
		IDLE:
			WalkingAnim(false)
			UpdateBlend()
			velocity = Vector2.ZERO
		FOLLOWTAMA:
			direction = to_local(navagent.get_next_path_position()).normalized()
			lastDirection = Tamaneko.global_position
			velocity = direction * stats.speed
			WalkingAnim(true)
			UpdateBlend()
			if navagent.distance_to_target() <= 30:
				currentState = IDLE
				StateMachine()
		COMBAT:
			if navagent.distance_to_target() >= 30:
				WalkingAnim(false)
				UpdateBlend()
				CastVoidBoltAnim(true)
				velocity = Vector2.ZERO
			if enemytarget == null:
				CastVoidBoltAnim(false)

#endregion



#region Animation

@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree

func WalkingAnim(value: bool):
	Animation_Tree["parameters/conditions/Walking"] = value
	Animation_Tree["parameters/conditions/Idle"] = not value


func CombatStance(value: bool):
	Animation_Tree["parameters/conditions/Combat"] = value
	Animation_Tree["parameters/conditions/Reset"] = not value
#
#func CastVoidPunchAnim(value: bool):
	#Animation_Tree["parameters/conditions/VoidPunch"] = value
	#Animation_Tree["parameters/conditions/Reset"] = not value

func CastVoidBoltAnim(value: bool):
	Animation_Tree["parameters/conditions/VoidBolt"] = value
	Animation_Tree["parameters/conditions/Reset"] = not value

func UpdateBlend():
	Animation_Tree["parameters/Idle/blend_position"] = direction
	Animation_Tree["parameters/Walking/blend_position"] = direction
	#Animation_Tree["parameters/Reset/blend_position"] = direction
	Animation_Tree["parameters/CombatStance/blend_position"] = direction
	#Animation_Tree["parameters/VoidPunch/blend_position"] = direction
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

