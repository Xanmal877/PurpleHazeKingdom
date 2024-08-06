class_name Slime extends CharacterBody2D



#region Variables

@onready var tama = get_tree().get_first_node_in_group("player")

@onready var slimestealthpanel = $Areas/Detectionbox/StealthPanel
@onready var ui = $UI
@onready var nametag = $UI/VBoxContainer/Nametag
@onready var healthbar = $UI/VBoxContainer/Healthbar
@onready var animation_tree = $Animations/AnimationTree


static var SlimesKilled: int = 0


var attributes: Dictionary = {

	"Strength": 8,
	"Dexterity": 8,
	"Constitution": 8,
	"Intelligence": 8,
	"Wisdom": 8,
	"Charisma": 8

	}


var stats: Dictionary = {
	"maxHealth": attributes["Constitution"] * 10,
	"maxStamina": attributes["Dexterity"] * 10,
	"maxMana": attributes["Intelligence"] * 10,

	"health": attributes["Constitution"] * 10,
	"stamina": attributes["Dexterity"] * 10,
	"mana": attributes["Intelligence"] * 10,

	"healthRegen": attributes["Constitution"] * 0.1,
	"staminaRegen": attributes["Dexterity"] * 0.1,
	"manaRegen": attributes["Wisdom"] * 0.1,

	"direction": Vector2(),
	"lastDirection": Vector2(),

	"speed": (attributes["Dexterity"] * 10) * 0.3,
	"normalSpeed": (attributes["Dexterity"] * 10) * 0.3,
	"sneakSpeed": (attributes["Dexterity"] * 10) * 0.2,
	"dashSpeed": (attributes["Dexterity"] * 10) * 1.5,

	"damage": (attributes["Strength"] * 10) * 0.2,
	"normalDamage":  (attributes["Dexterity"] * 10) * 0.2,
	"sneakDamage": (attributes["Dexterity"] * 10) * 0.2,
	"spellDamage": (attributes["Intelligence"] * 10) * 0.2,
}


#endregion


#region The Runtimes

func _ready():
	ui.hide()
	currentState = IDLE
	StateMachine()


func _process(_delta):
	healthbar.value = stats.health
	healthbar.max_value = stats.maxHealth
	OnDeath()


func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		Idle()

#endregion


#region StateMachine

enum {
	IDLE,
	EXPLORE,
	COMBAT,
}

var currentState
@onready var state_timeout = $Timers/StateTimeout
func StateMachine():
	Whatif()
	match currentState:
		IDLE:
			Idle()
		EXPLORE:
			Explore()
		COMBAT:
			Combat()


var ExploreDecision: Array = [EXPLORE, EXPLORE, IDLE]
func Whatif():
	if !EnemyArray.is_empty():
		currentState = COMBAT
	else:
		ExploreDecision.shuffle()
		var choose = ExploreDecision.front()
		currentState = choose

#endregion


#region States

#region Idle

var IdleTime = randf_range(1, 3)
@onready var idle_timer = $Timers/IdleTimer

func Idle():
	await get_tree().create_timer(IdleTime).timeout
	currentState = EXPLORE
	StateMachine()

#endregion


#region Explore

@onready var ExploreArray: Array = []
var randomRange = randi_range(20,100)

func Explore():
	ExploreArray.clear()
	if ExploreArray.is_empty():
		for i in range(6): # Generate 6 random positions
			var randomPos = get_random_position_nearby()
			ExploreArray.append(randomPos)
	ExploreArray.shuffle()
	var Marker = ExploreArray.pop_back()
	navagent.target_position = Marker

func get_random_position_nearby():
	var basePos = global_position
	var randomX = randf_range(basePos.x - randomRange, basePos.x + randomRange)
	var randomY = randf_range(basePos.y - randomRange, basePos.y + randomRange)
	return Vector2(randomX, randomY)

#endregion


#region Combat

var EnemyArray: Array = []

func EnemyDetected(area):
	if area.get_parent().get_parent().is_in_group("Tamaneko") or area.get_parent().get_parent().is_in_group("Autumn"):
		player = area.get_parent().get_parent()
		EnemyArray.append(player)
		currentState = COMBAT
		StateMachine()
		ui.show()
		if area.get_parent().get_parent().is_in_group("Tamaneko"):
			player.sneak = false


@onready var combat_timer = $Timers/CombatTimer
var player
func DamageEnemy(body):
	if body.is_in_group("Tamaneko") or body.is_in_group("Autumn"):
		player = body
		combat_timer.start(0.8)


func NotDamageEnemy(body):
	if body.is_in_group("Tamaneko") or body.is_in_group("Autumn"):
		player = null
		combat_timer.stop()


func InCombat():
	if player != null:
		player.stats.health -= stats.damage
		player.healthbar.Status()
	else:
		combat_timer.one_shot = true


var enemyTarget
func Combat():
	if !EnemyArray.is_empty():
		for enemy in EnemyArray:
			if enemy != null:
				enemyTarget = enemy
				navagent.target_position = enemyTarget.global_position


func EnemyLost(area):
	if area.get_parent().get_parent().is_in_group("Tamaneko") or area.get_parent().get_parent().is_in_group("Autumn"):
		player = null
		EnemyArray.erase(area.get_parent().get_parent())
		currentState = IDLE
		StateMachine()
		ui.hide()


#endregion


#endregion


#region Navigation

@onready var navagent = $navagent
func MakePath():
	if currentState == EXPLORE:
		stats.direction = to_local(navagent.get_next_path_position()).normalized()
		velocity = stats.direction * stats.speed
		if navagent.distance_to_target() <= 10:
			StateMachine()
	elif currentState == IDLE:
		velocity = Vector2.ZERO
	elif currentState == COMBAT:
		stats.direction = to_local(navagent.get_next_path_position()).normalized()
		velocity = stats.direction * stats.normalSpeed
		if enemyTarget != null:
			navagent.target_position = enemyTarget.global_position


#endregion


#region ItemDrops

const GOLD = preload("res://Scenes/Tools/Items/Gold.tscn")
const SLIME_GOO = preload("res://Scenes/Tools/Items/MonsterDrops/SlimeGoo.tscn")
func DropItems():
	var item1 = SLIME_GOO.instantiate()
	get_parent().call_deferred("add_child", item1)
	item1.position = position


	for i in range(randi_range(1,5)):
		var item2 = GOLD.instantiate()
		get_parent().call_deferred("add_child", item2)
		item2.position = (position + Vector2(5,0))

#endregion


func OnDeath():
	if stats.health <= 0:
		DropItems()
		Slime.SlimesKilled += 1
		queue_free()

