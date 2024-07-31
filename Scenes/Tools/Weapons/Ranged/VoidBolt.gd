extends Area2D

@onready var VoidBolt = $"."
@onready var spelltimeout = $Timeout
@onready var Sakilera = get_tree().get_first_node_in_group("Autumn")
@onready var Tamaneko = get_tree().get_first_node_in_group("Tamaneko")

var Direction
var velocity = Vector2.RIGHT
var speed: int = 500
var Damage = 60

func _ready():
	spelltimeout.start(0.6)
	Direction = Sakilera.direction
	print("Voidbolt Summoned")
	


func _physics_process(delta):
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

