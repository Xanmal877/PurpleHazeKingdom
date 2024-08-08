class_name Tamaneko extends GameStats


#region Variables

#var questTab: Array[MissionResource]

@onready var tamaneko = $"."
@onready var inventory = $UI/Inventory


@onready var ui = $UI
@onready var regenerationtimer = $Timers/RegenerationTimer
@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree
@onready var camera = $Camera2D

@onready var healthbar = $UI/Healthbar
@onready var staminabar = $UI/Staminabar


#endregion


#region The Runtimes

func _ready():
	requiredXP = (level * 1.5) * 100
	GameManager.connect("AttackMade", TakeDamage)
	GameManager.connect("MonsterKilled", SlimeKilled)
	StatUpdates()


func _process(delta):
	Death()


func _physics_process(_delta):
	Movement()
	DashAbility()
	Attack()
	Stealth()
	move_and_slide()


func _input(_event):
	OpenMenus()

#endregion


func SlimeKilled(Killer, XPvalue, GoldValue):
	if Killer != self:
		return
	currentXP += XPvalue
	gold += GoldValue
	print(gold)



#region Movement

#region Basic Movement

func Movement():
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO and !isAttacking:
		if abs(direction.x) > abs(direction.y):
			direction.y = 0
		else:
			direction.x = 0
		WalkingAnim(true)
		lastDirection = direction
		if !isDashing:
			velocity = direction.normalized() * speed
		if isDashing:
			velocity = direction * dashSpeed
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
		if sneak and stamina >= 1:
			SneakBox.shape.radius = 20
			stealth_panel.visible = true
			charactersprite.self_modulate = Color(1,0.157,1,0.35)
			speed = sneakSpeed
			damage = sneakDamage
			sneak_timer.start(0.4)
			stamina -= 1
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
			damage = normalDamage
			speed = normalSpeed
			sneak = false
			sneak_timer.stop()


#endregion


#region Dash

@onready var dash_timer = $Timers/DashTimer
var isDashing: bool = false
func DashAbility():
	if Input.is_action_just_pressed("Dash") and stamina >= 20:
		isDashing = true
		dash_timer.start(0.5)
		stamina -= 20
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
		if Input.is_action_just_pressed("Left Click") and stamina >= 2:
			SwingKatanaAnim(true)
			stamina -= 2
			staminabar.Status()
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false
		elif Input.is_action_pressed("Right Click") and stamina >= 1:
			ThrowShurikenAnim(true)
			stamina -= 1
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
		enemy.health -= damage



func EnemyLost(body):
	if body.is_in_group("enemy"):
		enemyArray.erase(body)


func TakeDamage(Attacker, Attacked, Damage):
	if Attacked != self:
		return

	health -= Damage
	healthbar.Status()
	staminabar.Status()


#endregion


#region ItemSlots

@onready var inventoryui = $UI/Inventory
@onready var character_list = $"../../CanvasLayer/Character List"


func OpenMenus():
	if Input.is_action_just_pressed("Inventory"):
		if inventoryui.visible == false:
			inventoryui.visible = true
		else:
			inventoryui.visible = false
	if inventoryui.visible or character_list.visible:
		inmenu = true
	else:
		inmenu = false




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
	Animation_Tree["parameters/Idle/blend_position"] = lastDirection
	Animation_Tree["parameters/Walk/blend_position"] = lastDirection
	Animation_Tree["parameters/Swing Katana/blend_position"] = lastDirection
	Animation_Tree["parameters/Throw Shuriken/blend_position"] = lastDirection

#endregion


#region Other


func Death():
	if health <= 0:
		get_tree().change_scene_to_file("res://Scenes/UI/GameOver.tscn")


#region Regeneration

@onready var regeneration_timer = $Timers/RegenerationTimer
func RegenerationTimeout():
	if health < maxHealth:
		health += healthRegen
	if stamina < maxStamina:
		stamina += staminaRegen
	#if mana < maxMana:
		#mana += manaRegen
	healthbar.Status()
	staminabar.Status()
	#manabar.Status()

#endregion

#endregion

func LevelUp(Killer, XPvalue, GoldValue):
	super.LevelUp(Killer, XPvalue, GoldValue)
	Strength += 2
	Constitution += 2
	StatUpdates()
