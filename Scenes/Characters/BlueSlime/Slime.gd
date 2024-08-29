class_name Slime extends CharacterBody2D


#region Variables

# Idle Variables
var currentState
var IdleTime = randf_range(3, 5)

# Explore Variables
@onready var ExploreArray: Array[Vector2] = []
var RandomRange: int = randi_range(100,150)
var Marker: Vector2

@onready var ui = $UI
@onready var nametag = $UI/VBoxContainer/Nametag
@onready var healthbar = $UI/VBoxContainer/Healthbar
@onready var animation_tree = $Animations/AnimationTree
@onready var damager_timer = $Timers/DamagerTimer
@export var stats: CharacterStats

#endregion



#region Runtimes

func _ready():
	currentState = IDLE
	StateMachine()
	GameManagement()
	stats.StatUpdates()

func _physics_process(_delta):
	damagevisual.max_value = damager_timer.wait_time
	damagevisual.value = damager_timer.time_left
	Movement()

func GameManagement():
	GameManager.connect("AttackMade", TakeDamage)
	

#endregion


func Movement():
	if currentState == IDLE:
		velocity = Vector2.ZERO
	elif currentState == COMBAT and target != null:
		stats.direction = global_position.direction_to(target.global_position)
		velocity = stats.direction * stats.speed * 0.4
	elif currentState == EXPLORE:
		stats.direction = global_position.direction_to(Marker)
		velocity = stats.direction * stats.speed * 0.2
	move_and_slide()


enum {
	IDLE,
	EXPLORE,
	COMBAT,
}


func StateMachine():
	if target != null:
		currentState = COMBAT
	match currentState:
		IDLE:
			await get_tree().create_timer(IdleTime).timeout
			currentState = EXPLORE
			StateMachine()
		EXPLORE:
			Marker = get_random_position_nearby()
			if global_position.distance_to(Marker) <= 20:
				currentState = IDLE
				StateMachine()
		COMBAT:
			pass


func get_random_position_nearby() -> Vector2:
	var random_x = randf_range(global_position.x - RandomRange, global_position.x + RandomRange)
	var random_y = randf_range(global_position.y - RandomRange, global_position.y + RandomRange)
	return Vector2(random_x, random_y)


var target
func DetectionRadar():
	var adventurers = get_tree().get_nodes_in_group("Adventurer")
	for adv in adventurers:
		if global_position.distance_to(adv.global_position) <= stats.detectionRadius:
			if target == null:
				target = adv
				damagevisual.show()
				damager_timer.start()
				currentState = COMBAT
				StateMachine()
		else:
			currentState = IDLE
			StateMachine()
			target = null
			damager_timer.stop()
			damagevisual.hide()

@onready var damagevisual = $DamageVisual


func DetectionTimeout():
	DetectionRadar()


func DamageEnemy():
	if target != null and global_position.distance_to(target.global_position) <= 20:
		stats.direction = global_position.direction_to(target.global_position)
		GameManager.emit_signal("AttackMade", self, target, stats.Damage)


func TakeDamage(Attacker, Attacked, Damage):
	if Attacked != self:
		return

	stats.health -= Damage
	HealthStatus()
	Death()
	if stats.health <= 0:
		GameManager.emit_signal("MonsterKilled", Attacker, 35, randi_range(3, 5))


func HealthStatus():
	healthbar.value = stats.health
	healthbar.max_value = stats.maxHealth



@onready var worldnode = get_tree().get_first_node_in_group("worldnode")
const SLIME_GOO = preload("res://Scenes/Tools/Items/MonsterDrops/SlimeGoo.tscn")
func Death():
	if stats.health <= 0:
		var item1 = SLIME_GOO.instantiate()
		worldnode.call_deferred("add_child", item1)
		item1.position = position
		queue_free()


func LevelUp():
	stats.LevelUp()
	stats.StatUpdates()



func _on_visible_on_screen_notifier_2d_screen_entered():
	ui.show()


func _on_visible_on_screen_notifier_2d_screen_exited():
	ui.hide()
