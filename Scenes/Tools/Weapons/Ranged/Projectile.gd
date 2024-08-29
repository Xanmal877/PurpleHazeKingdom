class_name Projectile extends Area2D

#region Variables

var speed: int = 0
var velocity: Vector2 = Vector2.RIGHT
var direction: Vector2 

@onready var projectile = $"."
@onready var timeout = $Timeout
var player
var target

#endregion


#region Runtimes

func _ready():
	RangedProperties()
	velocity = direction * speed
	global_position = player.global_position

func _physics_process(delta):
	global_position += velocity * delta
	if is_in_group("rotating"):
		rotate(400 * delta)

#endregion

@onready var Anim = $AnimatedSprite2D
func RangedProperties():
	if is_in_group("arrow"):
		timeout.wait_time = 2
		speed = 300
		direction = player.stats.lastDirection
		rotation = get_angle_to(player.lastDirection)
	if is_in_group("shuriken"):
		Anim.play("Shuriken")
		timeout.wait_time = 1
		speed = 300
		direction = player.stats.lastDirection
	if is_in_group("VoidBolt"):
		Anim.play("VoidBolt")
		speed = 100
		timeout.wait_time = 10
		if target != null:
			direction = player.global_position.direction_to(target.global_position)
			rotation = get_angle_to(target.global_position)
		else:
			direction = Vector2.RIGHT


func EnemyHit(area):
	if area.is_in_group("enemyHitbox"):
		var enemy = area.get_owner()
		if self.is_in_group("shuriken"):
			GameManager.emit_signal("AttackMade", player, enemy, player.stats.Damage)
		if self.is_in_group("VoidBolt"):
			GameManager.emit_signal("AttackMade", player, enemy, player.stats.spellDamage)
		player.healthbar.Status()
		player.staminabar.Status()
		player.manabar.Status()
		enemy.HealthStatus()
		queue_free()
	else:
		pass


func Timeout():
	projectile.queue_free()


#func TileMapEntered(body):
	#if body.is_in_group("tilemap"):
		#queue_free()
