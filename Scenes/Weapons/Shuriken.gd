extends Area2D

@onready var shuriken = $"."
@onready var shurikentimeout = $ShurikenTimeout
@onready var player = get_tree().get_first_node_in_group("player")
var Damage = 5

var Direction
var velocity = Vector2.RIGHT
var throwSpeed: int = 500


func _ready():
	shurikentimeout.start(0.6)
	if player.lastDirection != null:
		Direction = player.lastDirection
	else:
		Direction = Vector2.DOWN


func _physics_process(delta):
	position += velocity * delta
	rotate(400 * delta)
	velocity = Direction * throwSpeed


signal hitenemy
func EnemyHit(body):
	if body.is_in_group("enemy"):
		var enemy = body
		var damageDealt = max(1, player.damage + Damage)
		enemy.stats.Health -= damageDealt
		if enemy.stats.Health <= 0:
			player.CurrentXP += enemy.stats.XPValue
			enemy.queue_free()
		queue_free()
	else:
		pass


func ShurikenTimeout():
	shuriken.queue_free()


func ShurikenLeftScreen():
	queue_free()


func TileMapEntered(_body):
	if is_in_group("Tilemap"):
		queue_free()
