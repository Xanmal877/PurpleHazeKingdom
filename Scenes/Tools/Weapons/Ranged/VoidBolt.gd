extends Area2D

@onready var VoidBolt = $"."
@onready var spelltimeout = $Timeout

@onready var user

var Direction
var velocity = Vector2(0,0)
var speed: int = 400
var Damage = 60


func _ready():
	settarget()
	spelltimeout.start(1)
	global_position = user.global_position

func settarget():
	var target = user.target
	if target != null:
		var projectiledirection = (target.global_position - global_position).normalized()
		Direction = projectiledirection
		velocity = projectiledirection * speed


func _physics_process(delta):
	settarget()
	position += velocity * delta
	rotate(400 * delta)



func EnemyHit(body):
	if body.is_in_group("enemy"):
		var enemy = body
		enemy.stats.health -= Damage
		Knockback(enemy, body)
		#if enemy.stats.health <= 0:
			#Sakilera.stats.CurrentXP += enemy.stats.XPValue
			#Tamaneko.stats.CurrentXP += enemy.stats.XPValue * 0.5
		queue_free()
	else:
		pass


func VoidBoltTimeout():
	VoidBolt.queue_free()


func VoidBoltLeftScreen():
	queue_free()


func TileMapEntered(_body):
	queue_free()



func Knockback(enemy, _body):
	var pushback = (enemy.global_position - global_position).normalized() * 30
	var KnockbackTween = create_tween()
	if enemy != null:
		KnockbackTween.tween_property(enemy, "position", enemy.position + pushback, 0.2)

