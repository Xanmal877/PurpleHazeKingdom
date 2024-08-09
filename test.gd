extends Node


#region Generate Random Position

@export var minX: int
@export var maxX: int
@export var minY: int
@export var maxY: int

func generateRandomPosition() -> Vector2:
	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)

	var local_position = Vector2(randomX, randomY)
	@warning_ignore("shadowed_variable_base_class")
	var global_position = local_position

	return global_position

#endregion
