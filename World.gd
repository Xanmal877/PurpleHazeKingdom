extends Node2D

@onready var world = $"."
#const ROUTE_1 = preload("res://Scenes/Zones/Route1.tscn")

func _ready():
	pass
	var R1 = Global.ROUTE_1.instantiate()
	world.add_child(R1)
