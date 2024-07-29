extends Node2D

@onready var world = $"."
#const ROUTE_1 = preload("res://Scenes/Zones/Route1.tscn")
const TAMANEKO = preload("res://Scenes/Characters/Tamaneko.tscn")


func _ready():
	pass
	#var player = TAMANEKO.instantiate()
	#world.add_child(player)
	#player.global_position = Vector2(250,250)
	var zone = Global.ROUTE_1.instantiate()
	world.add_child(zone)


