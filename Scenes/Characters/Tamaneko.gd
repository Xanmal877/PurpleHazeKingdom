class_name TamanekoClass extends CharacterBody2D


#region Variables

@onready var tamaneko = $"."

var health: int = 20
var stamina: int = 20

var maxHealth: int = 20
var maxStamina: int = 20

var speed: int = 120
var normalSpeed: int = 120
@warning_ignore("integer_division")
var sneakSpeed: int = (speed / 2)

var damage: int = 20
var normalDamage: int = 20
var sneakDamage: int = (normalDamage * 4)

@onready var inventory = $UI/Inventory

var questTab: Array[MissionResource]

var direction
var lastDirection

@onready var regenerationtimer = $Timers/RegenerationTimer
@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree
@onready var camera = $Camera2D

@onready var healthbar = $UI/HBoxContainer/Bars/Healthbar
@onready var staminabar = $UI/HBoxContainer/Bars/Staminabar

#endregion


#region The Runtimes

func _ready():
	pass


func _process(_delta):
	healthbar.value = health
	staminabar.value = stamina


func _physics_process(_delta):
	Movement()
	Attack()
	Stealth()
	move_and_slide()


func _input(_event):
	UseHealthPotion()
	OpenMenus()
	#UseStaminaPotion()


#endregion


#region Movement

func Movement():
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO and isAttacking == false:
		if abs(direction.x) > abs(direction.y):
			direction.y = 0
		else:
			direction.x = 0
		velocity = direction.normalized() * speed
		WalkingAnim(true)
		lastDirection = direction
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
		print(sneak)
		tamaneko.set_collision_layer_value(1, !sneak)
		SneakCost()


func SneakCost():
		if sneak and stamina >= 1:
			charactersprite.self_modulate = Color(1,1,1,0.35)
			speed = sneakSpeed
			damage = sneakDamage
			sneak_timer.start(0.4)
			stamina -= 1
		else:
			charactersprite.self_modulate = Color(1,1,1,1)
			damage = normalDamage
			speed = normalSpeed
			sneak = false
			sneak_timer.stop()
		print(stamina)


#endregion


#region Combat

var enemyArray: Array = []

func EnemyDetected(body):
	if body.is_in_group("enemy"):
		enemyArray.append(body)


var inmenu: bool = false
var isAttacking: bool = false
const SHURIKEN = preload("res://Scenes/Tools/Weapons/Shuriken.tscn")
func Attack():
	if !isAttacking and inmenu == false:
		if Input.is_action_pressed("SwingKatana"):
			SwingKatanaAnim(true)
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false
		elif Input.is_action_pressed("ThrowShuriken") and stamina >= 5:
			ThrowShurikenAnim(true)
			var shuriken = SHURIKEN.instantiate()
			shuriken.player = $"."
			add_child(shuriken)
			shuriken.global_position = self.global_position
			stamina -= 5
			isAttacking = true
			await get_tree().create_timer(0.5).timeout
			isAttacking = false


func DamageEnemy(body):
	if body.is_in_group("enemy"):
		var enemy = body
		enemy.health -= damage
		#if enemy != null:
			#Knockback(enemy, body)
		if enemy != null and enemy.health <= 0:
			enemy.DropItem()
			enemy.queue_free()


func EnemyLost(body):
	if body.is_in_group("enemy"):
		enemyArray.erase(body)

#endregion


#region ItemSlots

@onready var inventoryui = $UI/Inventory
@onready var crafting_menu = $UI/CraftingMenu
func OpenMenus():
	if Input.is_action_just_pressed("Inventory"):
		if inventoryui.visible == false:
			inventoryui.visible = true
		else:
			inventoryui.visible = false
	if Input.is_action_just_pressed("CraftingTable"):
		if crafting_menu.visible == false:
			crafting_menu.visible = true
		else:
			crafting_menu.visible = false
		
	if inventoryui.visible or crafting_menu.visible:
		inmenu = true
	else:
		inmenu = false


func UseHealthPotion():
	if Input.is_action_just_pressed("Slot 1"):
		for i in inventory.Items:
			if i.name == "Health Potion":
				if i.amount > 0 and health != maxHealth:
					health += 5
					i.amount -= 1
					print(i.name, ":  ", i.amount)


func UseStaminaPotion():
	if Input.is_action_just_pressed("Slot 2"):
		for i in inventory.Items:
			if i.name == "Stamina Potion":
				if i.amount > 0:
					stamina += 5
					i.amount -= 1
					print(i.name, ":  ", i.amount)


#func UseManaPotion():
	#for i in inventory:
		#if i.name == "Health Potion":
			#if i.amount > 0:
				#mana += 5
				#i.amount -= 1
				#print(i.name, ":  ", i.amount)



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


#region Quest

var QuestGiverhere: bool = false
func DetectQuestGiver(body):
	if body.is_in_group("QuestGiver"):
		var NPC = body
		print(NPC)
		QuestGiverhere = true
		NPC.quest_slot.visible = true


#endregion


#region Other

#const GAME_OVER = preload("res://Scenes/GUI/Menus/GameOver.tscn")
#func Death():
	#if health <= 0:
		#var GameOverScene = GAME_OVER.instantiate()
		#self.add_child(GameOverScene)


func Knockback(enemy, body):
	var pushback = Vector2(0, 0)
	var KnockbackTween = get_tree().create_tween()

	if lastDirection == Vector2.LEFT:
		pushback.x = -5
	elif lastDirection == Vector2.RIGHT:
		pushback.x = 5
	elif lastDirection == Vector2.DOWN:
		pushback.y = 5
	elif lastDirection == Vector2.UP:
		pushback.y = -5

	if body.is_in_group("enemy"):
		if enemy.is_inside_tree():
			KnockbackTween.tween_property(enemy, "position", enemy.position + pushback, 0.2)


func RegenerationTimeout():
	#if health < maxHealth:
		#health += 1
	if stamina < maxStamina:
		stamina += 5

#endregion

