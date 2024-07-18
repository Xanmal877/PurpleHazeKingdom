extends CharacterBody2D


#region Variables

var health: int = 100
var stamina: int = 100
var mana: int = 100

var maxHealth: int = 100
var maxStamina: int = 100
var maxMana: int = 100

var speed: int = 120
var damage: int = 20

var direction
var lastDirection


@onready var regenerationtimer = $Timers/RegenerationTimer
@onready var Animation_Player = $Animations/AnimationPlayer
@onready var Animation_Tree = $Animations/AnimationTree
@onready var camera = $Camera2D

#endregion


#region The Runtimes

func _ready():
	pass



func _process(_delta):
	pass


func _physics_process(_delta):
	Movement()
	Attack()
	move_and_slide()

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


#region Combat

var enemyArray: Array = []

func EnemyDetected(body):
	if body.is_in_group("enemy"):
		enemyArray.append(body)


var isAttacking: bool = false
const SHURIKEN = preload("res://Scenes/Weapons/Shuriken.tscn")
func Attack():
	if Input.is_action_pressed("SwingKatana") and !isAttacking:
		SwingKatanaAnim(true)
		isAttacking = true
		await get_tree().create_timer(0.5).timeout
		isAttacking = false
	elif Input.is_action_pressed("ThrowShuriken") and stamina >= 5 and !isAttacking:
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
		if enemy != null:
			Knockback(enemy, body)
		if enemy != null and enemy.health <= 0:
			enemy.queue_free()


func EnemyLost(body):
	if body.is_in_group("enemy"):
		enemyArray.erase(body)

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
	if health < maxHealth:
		health += 1
	if stamina < maxStamina:
		stamina += 1
	if mana < maxMana:
		mana += 1

#endregion

