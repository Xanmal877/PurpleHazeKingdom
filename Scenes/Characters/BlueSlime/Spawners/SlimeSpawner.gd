extends Node2D


@export var SpawnedBlueSlimes: Node2D
@export var tilemap: TileMap
@export var MaxBlueSlimes: int
@onready var spawntimer = $SpawnTimer

@export var minX: int
@export var maxX: int
@export var minY: int
@export var maxY: int

const BLUESLIME = preload("res://Scenes/Characters/BlueSlime/Blueslime.tscn")
func SpawnBlueSlime():
	var blueslime = BLUESLIME.instantiate()
	SpawnedBlueSlimes.add_child(blueslime)
	blueslime.global_position = generateRandomPosition()

func generateRandomPosition() -> Vector2:
	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)

	var local_position = Vector2(randomX, randomY)
	@warning_ignore("shadowed_variable_base_class")
	var global_position = local_position

	return global_position


@onready var blue_slimes = $BlueSlimes
@onready var spawn_timer = $SpawnTimer

func SpawnTimer():
	if SpawnedBlueSlimes.get_child_count() < 25:
		spawntimer.wait_time = 0.5
	if SpawnedBlueSlimes.get_child_count() > 25:
		spawntimer.wait_time = 3
	if SpawnedBlueSlimes.get_child_count() < MaxBlueSlimes:
		SpawnBlueSlime()
		#print("Slimes:  " + str(blue_slimes.get_child_count()))

