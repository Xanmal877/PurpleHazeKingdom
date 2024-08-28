class_name Tamaneko extends CharacterBody2D


#region Variables

static var fourDirection: bool = true
@export var Sprite: Sprite2D
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
	#stats.CatchUpLevel()
	print(
	"Level:  " + str(stats.level) +
	"\n" + "Strength:  " + str(stats.Strength) +
	"\n" + "Dexterity:  " + str(stats.Dexterity) +
	"\n" + "Perception:  " + str(stats.Perception) +
	"\n" + "Constitution:  " + str(stats.Constitution) +
	"\n" + "Intelligence:  " + str(stats.Intelligence)
	)



func _process(delta):
	GM.GameTimer($"../../CanvasLayer/TimeLabel")

func _physics_process(_delta):
	Movement()
	move_and_slide()

func _input(_event):
	UseWeapon()
	OpenMenus()


func GameManagerReady():
	GM.connect("AttackMade", TakeDamage)
	GM.connect("MonsterKilled", MonsterKilled)
	GM.SetCameraLimits(region_one, tamaneko.camera)

#endregion


var isSneaking: bool = false
var isDashing: bool = false
func Movement():

# Directional Movement Code Section
	if fourDirection == true:
		if abs(stats.direction.x) > abs(stats.direction.y):
			stats.direction.y = 0
		else:
			stats.direction.x = 0

# Simple Movement code Section
	stats.direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if stats.direction != Vector2.ZERO and !isAttacking:
		WalkingAnim(true)
		stats.lastDirection = stats.direction
		if isDashing == true:
			velocity = stats.direction.normalized() * stats.dashSpeed
		elif isSneaking == true:
			velocity = stats.direction.normalized() * stats.sneakSpeed
		else:
			velocity = stats.direction.normalized() * stats.speed
	else:
		velocity = Vector2.ZERO
		WalkingAnim(false)
	UpdateBlend()

# Sneaking Code Section
	if Input.is_action_just_pressed("Sneak") and stats.stamina >= 5:
		isSneaking = !isSneaking
		stats.stamina -= 5
		staminabar.Status()
	if isSneaking:
		Sprite.self_modulate = Color(1,0.157,1,0.35)
	else:
		Sprite.self_modulate = Color(1,1,1,1)

# Dashing Code Section
	if Input.is_action_just_pressed("Dash") and stats.stamina >= 5:
		isDashing = true
		stats.stamina -= 5
		staminabar.Status()
		var tween = get_tree().create_tween()
		tween.tween_property(self, "modulate", Color(1,0.157,1,0.078), 0.2)
		tween.tween_property(self, "modulate", Color(1,1,1,1), 0.2)
		await get_tree().create_timer(0.5).timeout
		isDashing = false


#region Combat

var isAttacking: bool = false
func UseWeapon():
	const SHURIKEN = preload("res://Scenes/Tools/Weapons/Ranged/Shuriken.tscn")
	if !isAttacking and inmenu == false:
		
		# Swing Katana Code Section
		if Input.is_action_just_pressed("Left Click") and stats.stamina >= 2:
			SwingKatanaAnim(true)
			stats.stamina -= 2
			staminabar.Status()
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false

		# Throw shuriken Code Section
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


func DoDamage(area):
	if area.is_in_group("enemyHitbox"):
		var target = area.get_owner()
		var damagetype
		if isSneaking:
			damagetype = stats.sneakDamage
		else:
			damagetype = stats.Damage
		GameManager.emit_signal("AttackMade", self, target, damagetype)


func TakeDamage(Attacker, Attacked, Damage):
	if Attacked != self:
		return
	stats.health -= Damage
	healthbar.Status()
	staminabar.Status()
	CheckDeath()


func MonsterKilled(Killed, XPvalue, GoldValue):
	#if Killed != self:
		#return
	stats.currentXP += XPvalue
	stats.gold += GoldValue
	expbar.Status()
	print("currentXP:  ", stats.currentXP, "  Experience Needed: ", stats.requiredXP)
	stats.StatUpdates()


@onready var game_over = $"../../GameOver"
func CheckDeath():
	# Death Code
	if stats.health <= 0:
		game_over.visible = true

#endregion


@onready var character_sheet = $UI/CharacterSheet
@onready var inventoryui = $UI/Inventory
@onready var mainmenu = $"../../Main Menu"
var inmenu: bool = false
func OpenMenus():
	if Input.is_action_just_pressed("Inventory"):
		if inventoryui.visible == false:
			inventoryui.visible = true
		else:
			inventoryui.visible = false

	if Input.is_action_just_pressed("Escape"):
		mainmenu.visible = !mainmenu.visible
	
	if Input.is_action_just_pressed("Character Sheet"):
		character_sheet.visible = !character_sheet.visible

	if inventoryui.visible or mainmenu.visible:
		inmenu = true
		get_tree().paused = true
	else:
		inmenu = false
		get_tree().paused = false


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


func Regeneration():
	if stats.health < stats.maxHealth:
		stats.health += stats.healthRegen
	if stats.stamina < stats.maxStamina:
		stats.stamina += stats.staminaRegen
	healthbar.Status()
	staminabar.Status()
	expbar.Status()
