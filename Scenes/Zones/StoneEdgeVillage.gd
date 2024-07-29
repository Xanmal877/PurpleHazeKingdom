extends TileMap

@onready var player = get_tree().get_first_node_in_group("player")

const ROUTE_1 = preload("res://Scenes/Zones/Route1.tscn")


func ToRouteOne(body):
	if body.is_in_group("player"):
		var zone = ROUTE_1.instantiate()
		call_deferred("add_sibling", zone)
		player.global_position = Vector2(1050,350)
		player.stats.direction = Vector2.LEFT
		call_deferred("queue_free")
