extends Area2D

#region Variables

var speed: int = 0
var velocity: Vector2 = Vector2.RIGHT
var direction: Vector2 

@onready var projectile = $"."
@onready var timeout = $Timeout
@onready var player = get_tree().get_first_node_in_group("Tamaneko")

#endregion


#region Runtimes

func _ready():
	if player.stats.lastDirection != Vector2.ZERO:
		RangedProperties()
		velocity = direction * speed
	else:
		direction = Vector2.RIGHT


func _physics_process(delta):
	global_position += velocity * delta
	if is_in_group("rotating"):
		rotate(400 * delta)

#endregion


func RangedProperties():
	if is_in_group("arrow"):
		speed = 300
		direction = player.lastDirection
		rotation = get_angle_to(player.lastDirection)
	if is_in_group("shuriken"):
		speed = 300
		direction = player.stats.lastDirection


func EnemyHit(body):
	if body.is_in_group("enemy"):
		var enemy = body
		enemy.stats.health -= 1
		if enemy.currentState != enemy.COMBAT:
			enemy.target = player
			enemy.currentState = enemy.COMBAT
			enemy.StateMachine()
			enemy.ui.show()
		if enemy.stats.health <= 0:
			#player.CurrentXP += enemy.XPValue
			enemy.queue_free()
		queue_free()
	else:
		pass


func Timeout():
	projectile.queue_free()


func LeftScreen():
	queue_free()


func TileMapEntered(body):
	if body.is_in_group("tilemap"):
		queue_free()
