class_name SlimeSpawner extends Node2D


#region Generate Random Position

@export var SpawnMarkers: Node2D

func generateRandomPosition() -> Vector2:
	var Markers = SpawnMarkers.get_children()
	var marker = Markers.pick_random()
	return marker.global_position

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
	if Spawned.get_child_count() < 25:
		spawntimer.wait_time = 0.2
		Spawn()
	elif Spawned.get_child_count() < 60:
		spawntimer.wait_time = 1
		Spawn()
	else:
		pass
	#print(Spawned.get_child_count())


#endregion
