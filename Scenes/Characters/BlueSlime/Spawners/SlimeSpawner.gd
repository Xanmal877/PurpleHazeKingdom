class_name SlimeSpawner extends Node2D

#region Generate Random Position

@export var SpawnMarkers: Node2D

var originalMarkers: Array = [] 
var activeMarkers: Array = [] 

func _ready():
	originalMarkers = SpawnMarkers.get_children()
	activeMarkers = originalMarkers.duplicate()

func generateRandomPosition() -> Vector2:
	if activeMarkers.size() == 0:
		activeMarkers = originalMarkers.duplicate()
	var marker = activeMarkers.pick_random()
	activeMarkers.erase(marker)

	return marker.global_position

#endregion

#region Spawner

@export var Spawned: Node2D
@export var MaxSpawns: int
@onready var spawntimer = $SpawnTimer

const SLIME = preload("res://Scenes/Characters/BlueSlime/Slime.tscn")
func Spawn():
	var slime = SLIME.instantiate()
	Spawned.add_child(slime)
	slime.global_position = generateRandomPosition()

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
