extends Area2D

@onready var shuriken = $"."
@onready var shurikentimeout = $ShurikenTimeout
@onready var player = get_tree().get_first_node_in_group("player")

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


func EnemyHit(body):
	if body.is_in_group("enemy"):
		var enemy = body
		enemy.health -= 1
		if enemy.currentState != enemy.COMBAT:
			enemy.EnemyArray.append(player)
			enemy.currentState = enemy.COMBAT
			enemy.StateMachine()
			enemy.ui.show()
		if enemy.health <= 0:
			#player.CurrentXP += enemy.stats.XPValue
			enemy.queue_free()
		queue_free()
	else:
		pass


func ShurikenTimeout():
	shuriken.queue_free()


func ShurikenLeftScreen():
	queue_free()


func TileMapEntered(body):
	if body.is_in_group("Tilemap"):
		queue_free()
