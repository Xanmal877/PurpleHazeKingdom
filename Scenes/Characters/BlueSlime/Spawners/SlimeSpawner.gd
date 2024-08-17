class_name SlimeSpawner extends Node2D


#region Generate Random Position

@export var CArea: Area2D
@export var Cshape: CollisionShape2D

func generateRandomPosition() -> Vector2:
	var Cshapesize = Cshape.shape.size
	var spawnzone = Vector2(
		randi_range(-Cshapesize.x / 2, Cshapesize.x / 2),
		randi_range(-Cshapesize.y / 2, Cshapesize.y / 2)
	)
	spawnzone += CArea.global_position
	return spawnzone

#endregion


#region Spawner

@export var Spawned: Node2D
@export var MaxSpawns: int
@onready var spawntimer = $SpawnTimer

const BLUESLIME = preload("res://Scenes/Characters/BlueSlime/Blueslime.tscn")
func Spawn():
	var blueslime = BLUESLIME.instantiate()
	Spawned.add_child(blueslime)
	blueslime.global_position = generateRandomPosition()


func SpawnTimer():
	if Spawned.get_child_count() < MaxSpawns:
		Spawn()

#endregion
