class_name Tamaneko extends CharacterBody2D


#region Variables

static var fourDirection: bool = true

@onready var tamaneko = $"."
@onready var inventory = $UI/Inventory

@onready var ui = $UI
@onready var regenerationtimer = $Timers/RegenerationTimer
@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree
@onready var camera = $Camera2D

@onready var healthbar = $UI/Bars/Healthbar
@onready var staminabar = $UI/Bars/Staminabar
@onready var expbar = $UI/Bars/expbar


@onready var region_one = $"../../RegionOne"

@onready var GM: GameManager = GameManager
@export var stats: CharacterStats

#endregion


#region The Runtimes

func _ready():
	stats.StatUpdates()
	GameManagerReady()
	await get_tree().create_timer(0.5).timeout
	LevelUp(self, 0, 0)
	stats.StatUpdates()
	print("LeveL:  ", stats.level, "  Dexterity:  ", stats.Dexterity)

func _process(delta):
	GM.GameTimer($"../../CanvasLayer/TimeLabel")

func _physics_process(_delta):
	Movement()
	DashAbility()
	Attack()
	Stealth()
	move_and_slide()

func _input(_event):
	OpenMenus()


func GameManagerReady():
	GM.connect("AttackMade", TakeDamage)
	GM.connect("MonsterKilled", SlimeKilled)
	GM.SetCameraLimits(region_one, tamaneko.camera)


#endregion


#region Movement

#region Basic Movement

func Movement():
	stats.direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if stats.direction != Vector2.ZERO and !isAttacking:
		if fourDirection == true:
			if abs(stats.direction.x) > abs(stats.direction.y):
				stats.direction.y = 0
			else:
				stats.direction.x = 0
		WalkingAnim(true)
		stats.lastDirection = stats.direction
		if !isDashing:
			velocity = stats.direction.normalized() * stats.speed
		if isDashing:
			velocity = stats.direction * stats.dashSpeed
	else:
		velocity = Vector2.ZERO
		WalkingAnim(false)
	UpdateBlend()

#endregion


#region Sneaking

var sneak: bool = false
@onready var charactersprite = $Sprite2D
@onready var sneak_timer = $Timers/SneakTimer
@onready var stealth_panel = $Areas/StealthBox/StealthPanel
@onready var SneakBox = $Areas/StealthBox/CollisionShape2D

func Stealth():
	if Input.is_action_just_pressed("Sneak"):
		sneak = !sneak
		SneakCost()


func SneakCost():
		if sneak and stats.stamina >= 1:
			SneakBox.shape.radius = 20
			stealth_panel.visible = true
			charactersprite.self_modulate = Color(1,0.157,1,0.35)
			stats.speed = stats.sneakSpeed
			stats.damage = stats.sneakDamage
			sneak_timer.start(0.4)
			stats.stamina -= 1
			staminabar.Status()
			var slimegroup = get_tree().get_nodes_in_group("enemy")
			for slime in slimegroup:
				slime.slimestealthpanel.visible = true
		else:
			SneakBox.shape.radius = 40
			stealth_panel.visible = false
			var slimegroup = get_tree().get_nodes_in_group("enemy")
			for slime in slimegroup:
				slime.slimestealthpanel.visible = false
			charactersprite.self_modulate = Color(1,1,1,1)
			stats.damage = stats.normalDamage
			stats.speed = stats.normalSpeed
			sneak = false
			sneak_timer.stop()


#endregion


#region Dash

@onready var dash_timer = $Timers/DashTimer
var isDashing: bool = false
func DashAbility():
	if Input.is_action_just_pressed("Dash") and stats.stamina >= 20:
		isDashing = true
		dash_timer.start(0.5)
		stats.stamina -= 20
		staminabar.Status()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1,0.157,1,0.078), 0.2)
		tween.tween_property(self, "modulate", Color(1,1,1,1), 0.2)

func DashTimeout():
	isDashing = false
	Animation_Player.speed_scale = 1.0
	#speed = 0
	#WalkingAnim(false)
	#await get_tree().create_timer(0.5).timeout
	#speed = normalSpeed


#endregion

#endregion


#region Combat

var enemyArray: Array = []

func EnemyDetected(body):
	if body.is_in_group("enemy"):
		enemyArray.append(body)


var inmenu: bool = false
var isAttacking: bool = false
const SHURIKEN = preload("res://Scenes/Tools/Weapons/Ranged/Shuriken.tscn")
func Attack():
	if !isAttacking and inmenu == false:
		if Input.is_action_just_pressed("Left Click") and stats.stamina >= 2:
			SwingKatanaAnim(true)
			stats.stamina -= 2
			staminabar.Status()
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false
		elif Input.is_action_pressed("Right Click") and stats.stamina >= 1:
			ThrowShurikenAnim(true)
			stats.stamina -= 1
			staminabar.Status()
			var shuriken = SHURIKEN.instantiate()
			shuriken.player = $"."
			add_sibling(shuriken)
			shuriken.global_position = self.global_position
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false
			


func DamageEnemy(area):
	if area.is_in_group("enemyHitbox"):
		var enemy = area.get_owner()
		enemy.stats.health -= stats.damage



func EnemyLost(body):
	if body.is_in_group("enemy"):
		enemyArray.erase(body)


func TakeDamage(Attacker, Attacked, Damage):
	if Attacked != self:
		return

	stats.health -= Damage
	healthbar.Status()
	staminabar.Status()
	Death()

#endregion


#region Menus

@onready var inventoryui = $UI/Inventory
@onready var mainmenu = $"../../Main Menu"

func OpenMenus():
	if Input.is_action_just_pressed("Inventory"):
		if inventoryui.visible == false:
			inventoryui.visible = true
		else:
			inventoryui.visible = false

	if Input.is_action_just_pressed("Escape"):
		mainmenu.visible = !mainmenu.visible

	if inventoryui.visible or mainmenu.visible:
		inmenu = true
		get_tree().paused = true
	else:
		inmenu = false
		get_tree().paused = false

#endregion


#region Animation

func WalkingAnim(value: bool):
	Animation_Tree["parameters/conditions/Walk"] = value
	Animation_Tree["parameters/conditions/Idle"] = not value

func SwingKatanaAnim(value: bool):
	Animation_Tree["parameters/conditions/Swing"] = value


func ThrowShurikenAnim(value: bool):
	Animation_Tree["parameters/conditions/Throw"] = value


func UpdateBlend():
	Animation_Tree["parameters/Idle/blend_position"] = stats.lastDirection
	Animation_Tree["parameters/Walk/blend_position"] = stats.lastDirection
	Animation_Tree["parameters/Swing Katana/blend_position"] = stats.lastDirection
	Animation_Tree["parameters/Throw Shuriken/blend_position"] = stats.lastDirection

#endregion


#region Other

func LevelUp(Killed, XPvalue, GoldValue):
		for i in range(stats.level):
			stats.LevelUp(Killed, XPvalue, GoldValue)
			stats.Dexterity += 2
			stats.Charisma += 2
			stats.StatUpdates()


func SlimeKilled(Killed, XPvalue, GoldValue):
	#if Killed != self:
		#return
	stats.currentXP += XPvalue
	stats.gold += GoldValue
	expbar.Status()
	print("currentXP:  ", stats.currentXP, "  Experience Needed: ", stats.requiredXP)
	if stats.currentXP >= stats.requiredXP:
		LevelUp(Killed, XPvalue, GoldValue)



func Death():
	if stats.health <= 0:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")


#region Regeneration

@onready var regeneration_timer = $Timers/RegenerationTimer
func RegenerationTimeout():
	if stats.health < stats.maxHealth:
		stats.health += stats.healthRegen
	if stats.stamina < stats.maxStamina:
		stats.stamina += stats.staminaRegen
	healthbar.Status()
	staminabar.Status()
	expbar.Status()

#endregion

#endregion

