class_name Tamaneko extends CharacterBody2D


#region Variables

var attributes: Dictionary = {

	"Strength": 10,
	"Dexterity": 16,
	"Constitution": 10,
	"Intelligence": 10,
	"Wisdom": 10,
	"Charisma": 14
	}

var stats: Dictionary ={

	"maxHealth": attributes["Constitution"] * 10,
	"maxStamina": attributes["Dexterity"] * 10,
	"maxMana": attributes["Intelligence"] * 10,

	"health": attributes["Constitution"] * 10,
	"stamina": attributes["Dexterity"] * 10,
	"mana": attributes["Intelligence"] * 10,

	"healthRegen": attributes["Constitution"] * 0.01,
	"staminaRegen": attributes["Dexterity"] * 0.5,
	"manaRegen": attributes["Wisdom"] * 0.5,

	"direction": Vector2(),
	"lastDirection": Vector2(),

	"speed": (attributes["Dexterity"] * 10) * 0.5,
	"normalSpeed": (attributes["Dexterity"] * 10) * 0.5,
	"sneakSpeed": (attributes["Dexterity"] * 10) * 0.2,
	"dashSpeed": (attributes["Dexterity"] * 10) * 5,

	"damage": (attributes["Strength"] * 10) * 0.2,
	"normalDamage":  (attributes["Strength"] * 10) * 0.2,
	"sneakDamage": (attributes["Dexterity"] * 10) * 2,
	"spellDamage": (attributes["Intelligence"] * 10) * 0.5,}

var economy: Dictionary = {
	"Gold": 0
}

#var questTab: Array[MissionResource]

@onready var tamaneko = $"."
@onready var inventory = $UI/Inventory


@onready var regenerationtimer = $Timers/RegenerationTimer
@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree
@onready var camera = $Camera2D

@onready var healthbar = $UI/HBoxContainer/Bars/Healthbar
@onready var staminabar = $UI/HBoxContainer/Bars/Staminabar

#endregion


#region The Runtimes

func _physics_process(_delta):
	Movement()
	DashAbility()
	Attack()
	Stealth()
	Death()
	UseHealthPotion()
	UseStaminaPotion()
	move_and_slide()

func _input(_event):
	OpenMenus()

#endregion


#region Movement

#region Basic Movement

func Movement():
	stats.direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if stats.direction != Vector2.ZERO and !isAttacking:
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
		print(SneakBox.shape.radius)
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
			SneakBox.shape.radius = 80
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
	#stats.speed = 0
	#WalkingAnim(false)
	#await get_tree().create_timer(0.5).timeout
	#stats.speed = stats.normalSpeed


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
		if Input.is_action_pressed("SwingKatana") and stats.stamina >= 2:
			SwingKatanaAnim(true)
			stats.stamina -= 2
			staminabar.Status()
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false
		elif Input.is_action_pressed("ThrowShuriken") and stats.stamina >= 1:
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
			


func DamageEnemy(body):
	if body.is_in_group("enemy"):
		var enemy = body
		enemy.stats.health -= stats.damage


func EnemyLost(body):
	if body.is_in_group("enemy"):
		enemyArray.erase(body)


#endregion


#region ItemSlots

@onready var inventoryui = $UI/Inventory


func OpenMenus():
	if Input.is_action_just_pressed("Inventory"):
		if inventoryui.visible == false:
			inventoryui.visible = true
		else:
			inventoryui.visible = false
	if inventoryui.visible:
		inmenu = true
	else:
		inmenu = false


func UseHealthPotion():
	if Input.is_action_just_pressed("Slot 1"):
		for i in inventory.Items:
			if i.name == "Health Potion":
				if i.amount > 0 and stats.health != stats.maxHealth:
					stats.health += 10
					i.amount -= 1


func UseStaminaPotion():
	if Input.is_action_just_pressed("Slot 2"):
		for i in inventory.Items:
			if i.name == "Stamina Potion":
				if i.amount > 0:
					stats.stamina += 10
					i.amount -= 1

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
	#if stats.mana < stats.maxMana:
		#stats.mana += stats.manaRegen
	healthbar.Status()
	staminabar.Status()
	#manabar.Status()

#endregion

#endregion

