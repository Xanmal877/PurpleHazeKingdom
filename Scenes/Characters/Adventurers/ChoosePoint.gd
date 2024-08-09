extends ActionLeaf

@export var NavAgent: NavigationAgent2D

var travel: bool = false

var minX: int = 1180
var maxX: int = 2000
var minY: int = 500
var maxY: int = 1580


func CanUsePhysics(_state):
	if user.target == null or NavAgent.distance_to_target() <= 30:
		return true
	return false


func UseActionPhysics(_state):
	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)
	target = Vector2(randomX, randomY)
	NavAgent.target_position = target
	if NavAgent.distance_to_target() >= 100:
		user.target = target
		NavAgent.target_position = user.target

