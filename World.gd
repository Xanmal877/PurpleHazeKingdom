extends Node2D


const ROUTE_1 = preload("res://Scenes/Zones/Route1.tscn")


func _ready():
	var zone = ROUTE_1.instantiate()
	add_child(zone)
