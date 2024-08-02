class_name Slime extends CharacterBody2D


@onready var tama = get_tree().get_first_node_in_group("player")

#region Variables


var stats: Dictionary = {
	"health": 60,"stamina": 0,"mana": 0,"maxHealth": 60,"maxStamina": 0,"maxMana": 0,
	"direction": Vector2(),"lastDirection": Vector2(),
	"speed": 20,"normalSpeed": 20,"chaseSpeed": 40,
	"damage": 5,"normalDamage": 5,
	}


static var SlimesKilled: int = 0

@onready var ui = $UI
@onready var nametag = $UI/VBoxContainer/Nametag
@onready var healthbar = $UI/VBoxContainer/Healthbar
@onready var animation_tree = $Animations/AnimationTree


#endregion


#region The Runtimes


func _ready():
	ui.hide()
	currentState = IDLE
	StateMachine()


func _process(_delta):
	healthbar.value = stats.health
	healthbar.max_value = stats.maxHealth
	DropItem()


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
	#idle_timer.start(IdleTime)
	#await idle_timer.timeout
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
	NavAgent.target_position = Marker

func get_random_position_nearby():
	var basePos = global_position
	var randomX = randf_range(basePos.x - randomRange, basePos.x + randomRange)
	var randomY = randf_range(basePos.y - randomRange, basePos.y + randomRange)
	return Vector2(randomX, randomY)

#endregion


#region Combat

var EnemyArray: Array = []

func EnemyDetected(body):
	if body.is_in_group("Tamaneko") or body.is_in_group("Autumn"):
		EnemyArray.append(body)
		currentState = COMBAT
		StateMachine()
		ui.show()


@onready var combat_timer = $Timers/CombatTimer
var player
func DamageEnemy(body):
	if body.is_in_group("Tamaneko") or body.is_in_group("Autumn"):
		player = body
		combat_timer.start(0.4)
		combat_timer.one_shot = false


func InCombat():
	if player != null:
		player.stats.health -= stats.damage
	else:
		combat_timer.one_shot = true


var enemyTarget
func Combat():
	if !EnemyArray.is_empty():
		for enemy in EnemyArray:
			if enemy != null:
				enemyTarget = enemy
				NavAgent.target_position = enemyTarget.global_position


func EnemyLost(body):
	if body.is_in_group("Tamaneko") or body.is_in_group("Autumn"):
		player = null
		EnemyArray.erase(body)
		currentState = IDLE
		StateMachine()
		ui.hide()


#endregion


#endregion


#region Navigation

@onready var NavAgent = $NavigationAgent2D
func MakePath():
	if currentState == EXPLORE:
		stats.direction = to_local(NavAgent.get_next_path_position()).normalized()
		velocity = stats.direction * stats.speed
		if NavAgent.distance_to_target() <= 10:
			StateMachine()
	elif currentState == IDLE:
		velocity = Vector2.ZERO
	elif currentState == COMBAT:
		stats.direction = to_local(NavAgent.get_next_path_position()).normalized()
		velocity = stats.direction * stats.chaseSpeed
		if enemyTarget != null:
			NavAgent.target_position = enemyTarget.global_position


#endregion


#region ItemDrops

const SLIME_GOO = preload("res://Scenes/Tools/Items/MonsterDrops/SlimeGoo.tscn")
func DropItem():
	if stats.health <= 0:
		var goo = SLIME_GOO.instantiate()
		get_parent().call_deferred("add_child", goo)
		goo.position = position
		queue_free()

#endregion

