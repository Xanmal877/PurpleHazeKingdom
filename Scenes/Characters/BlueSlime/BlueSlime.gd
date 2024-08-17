class_name Slime extends CharacterBody2D


#region Variables

@onready var slimestealthpanel = $Areas/Detectbox/Stealthpanel
@onready var ui = $UI
@onready var nametag = $UI/VBoxContainer/Nametag
@onready var healthbar = $UI/VBoxContainer/Healthbar
@onready var animation_tree = $Animations/AnimationTree

@export var stats: CharacterStats


#endregion


#region The Runtimes

func _ready():
	nametag.text = str(stats.Name) + "\n" + "lvl:  " + str(stats.level)
	ui.hide()
	currentState = IDLE
	GameManagement()
	stats.StatUpdates()



func _process(_delta):
	OnDeath()
	

func _physics_process(_delta):
	if currentState == IDLE:
		velocity = Vector2.ZERO
		stats.speed = 0
	else:
		stats.speed = stats.normalSpeed
		velocity = stats.direction * stats.speed
	move_and_slide()


func GameManagement():
	GameManager.connect("AttackMade", TakeDamage)


#endregion


#region StateMachine

enum {
	IDLE,
	EXPLORE,
	COMBAT,
}

var currentState
func StateMachine():
	match currentState:
		IDLE:
			Idle()
		EXPLORE:
			Explore()
		COMBAT:
			DamageEnemy()

#endregion


#region States

#region Idle

var IdleTime = randf_range(1, 3)

func Idle():
	await get_tree().create_timer(IdleTime).timeout
	currentState = EXPLORE

#endregion


#region Explore

@onready var ExploreArray: Array[Vector2] = []
var RandomRange: int = randi_range(60,100)
var Marker: Vector2

func Explore():
	if ExploreArray.is_empty():
		for i in range(6):  # Generate 6 random positions
			var random_pos = get_random_position_nearby()
			ExploreArray.append(random_pos)
	ExploreArray.shuffle()
	Marker = ExploreArray.pop_back()
	stats.direction = global_position.direction_to(Marker)
	if global_position.distance_to(Marker) <= 20:
		currentState = IDLE

func get_random_position_nearby() -> Vector2:
	var random_x = randf_range(global_position.x - RandomRange, global_position.x + RandomRange)
	var random_y = randf_range(global_position.y - RandomRange, global_position.y + RandomRange)
	return Vector2(random_x, random_y)

#endregion


#region Combat

var target
var isincombat: bool = false
@onready var combat = $Timers/CombatTimer

func EnemyDetected(area):
	if area.get_owner().is_in_group("Adventurer"):
		target = area.get_owner()
		ui.show()
		currentState = COMBAT
		combat.start(0.5)

func EnemyNotDetected(area):
		target = null
		ui.hide()
		#currentState = IDLE
		combat.stop()


func InAttackRange(area):
	if area.get_owner().is_in_group("Adventurer"):
		isincombat = true



func NotInAttackRange(area):
	if area.get_owner().is_in_group("Adventurer"):
		isincombat = false



func DamageEnemy():
	if target != null:
		stats.direction = global_position.direction_to(target.global_position)
		if global_position.distance_to(target.global_position) <= 20:
			GameManager.emit_signal("AttackMade", self, target, stats.damage)


func TakeDamage(Attacker, Attacked, Damage):
	if Attacked != self:
		return

	stats.health -= Damage
	healthbar.value = stats.health
	healthbar.max_value = stats.maxHealth

#endregion


#endregion


#region DEATH

@onready var worldnode = get_tree().get_first_node_in_group("worldnode")
const SLIME_GOO = preload("res://Scenes/Tools/Items/MonsterDrops/SlimeGoo.tscn")
func DropItems():
	var item1 = SLIME_GOO.instantiate()
	worldnode.call_deferred("add_child", item1)
	item1.position = position


func OnDeath():
	if stats.health <= 0:
		DropItems()
		var goldvalue = randi_range(3,5)
		GameManager.emit_signal("MonsterKilled", self, 35, goldvalue)
		queue_free()

#endregion


func Regeneration():
	if isincombat == false:
		pass


func LevelUp(Killed, XPvalue, GoldValue):
	stats.LevelUp(Killed, XPvalue, GoldValue)
	stats.Strength += 2
	stats.Constitution += 2
	stats.StatUpdates()
