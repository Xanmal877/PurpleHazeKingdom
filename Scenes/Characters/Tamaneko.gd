extends CharacterBody2D


#region Variables

var attributes: Dictionary = {}

var stats: Dictionary = {
	"health": 60,"stamina": 200,"mana": 100,"maxHealth": 60,"maxStamina": 200,"maxMana": 100,
	"direction": Vector2(),"lastDirection": Vector2(),
	"speed": 80,"normalSpeed": 60,"sneakSpeed": 40,"dashSpeed": 600,
	"damage": 20,"normalDamage": 20,"sneakDamage": 20 * 4,}

var questTab: Array[MissionResource]

@onready var tamaneko = $"."
@onready var inventory = $UI/Inventory
@onready var quest_log = $UI/QuestLog


@onready var regenerationtimer = $Timers/RegenerationTimer
@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree
@onready var camera = $Camera2D

@onready var healthbar = $UI/HBoxContainer/Bars/Healthbar
@onready var staminabar = $UI/HBoxContainer/Bars/Staminabar

#endregion


#region The Runtimes

func _process(_delta):
	healthbar.value = stats.health
	staminabar.value = stats.stamina


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

func Stealth():
	if Input.is_action_just_pressed("Sneak"):
		sneak = !sneak
		tamaneko.set_collision_layer_value(1, !sneak)
		SneakCost()

@onready var regeneration_timer = $Timers/RegenerationTimer
func SneakCost():
		if sneak and stats.stamina >= 0.2:
			charactersprite.self_modulate = Color(1,0.157,1,0.35)
			stats.speed = stats.sneakSpeed
			stats.damage = stats.sneakDamage
			sneak_timer.start(0.4)
			stats.stamina -= 0.2
		else:
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
	if Input.is_action_just_pressed("Dash") and stats.stamina >= 4:
		isDashing = true
		dash_timer.start(0.5)
		stats.stamina -= 4
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
		if Input.is_action_pressed("SwingKatana"):
			SwingKatanaAnim(true)
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false
		elif Input.is_action_pressed("ThrowShuriken"):
			ThrowShurikenAnim(true)
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
		#if enemy != null:
			#Knockback(enemy, body)
		if enemy != null and enemy.stats.health <= 0:
			enemy.DropItem()
			Slime.SlimesKilled += 1
			print(enemy.SlimesKilled)


func EnemyLost(body):
	if body.is_in_group("enemy"):
		enemyArray.erase(body)

#endregion


#region ItemSlots

@onready var inventoryui = $UI/Inventory
@onready var quest_logui = $UI/QuestLog

func OpenMenus():
	if Input.is_action_just_pressed("Inventory"):
		if inventoryui.visible == false:
			inventoryui.visible = true
		else:
			inventoryui.visible = false
	if Input.is_action_just_pressed("QuestLog"):
		if quest_logui.visible == false:
			quest_logui.visible = true
		else:
			quest_logui.visible = false
	if inventoryui.visible or quest_logui.visible:
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


#region Quest

var QuestGiverhere: bool = false
func DetectQuestGiver(body):
	if body.is_in_group("QuestGiver"):
		QuestGiverhere = true
		#NPC.quest_slot.visible = true


#endregion


#region Other

func Death():
	if stats.health <= 0:
		get_tree().change_scene_to_file("res://GameOver.tscn")

func Knockback(enemy, body):
	var direction = stats.lastDirection
	var pushback = direction * Vector2(5, 5)
	
	if body.is_in_group("enemy") and enemy.is_inside_tree():
		var KnockbackTween = get_tree().create_tween()
		KnockbackTween.tween_property(enemy, "position", enemy.position + pushback, 0.2)



func RegenerationTimeout():
	if !sneak and !isDashing:
		if stats.stamina < stats.maxStamina:
			stats.stamina += 1

#endregion

