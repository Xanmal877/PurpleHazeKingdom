extends ActionLeaf

@export var CArea: Area2D
@export var Cshape: CollisionShape2D
@export var NavAgent: NavigationAgent2D


func CanUsePhysics(_state):
	if user.target == null:
		return true
	return false


func UseActionPhysics(_state):
	var Cshapesize = Cshape.shape.size
	var spawnzone = Vector2(
		randi_range(-Cshapesize.x / 2, Cshapesize.x / 2),
		randi_range(-Cshapesize.y / 2, Cshapesize.y / 2)
	)
	spawnzone += CArea.global_position
	user.target = spawnzone
	NavAgent.target_position = user.target

