extends TileMap


@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	Global.set_camera_limits($".", player.camera)
	var LS = Global.LOADING_SCREEN.instantiate()
	add_child(LS)



const ROUTE_1 = preload("res://Scenes/Zones/Route1.tscn")
func Route1(body):
	if body.is_in_group("player"):
		var pi = ROUTE_1.instantiate()
		get_parent().call_deferred("add_child", pi)
		player.global_position = Vector2(30,600)
		call_deferred("queue_free")
