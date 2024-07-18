extends TileMap

@onready var player = get_tree().get_first_node_in_group("player")
@onready var trellark_forest = $"."



func _ready():
	player.camera.enabled = true
	Global.set_camera_limits(trellark_forest, player.camera)
	var LS = Global.LOADING_SCREEN.instantiate()
	add_child(LS)


func Route1(body):
	print("Route1")
	if body.is_in_group("player"):
		var R1 = Global.ROUTE_1.instantiate()
		get_parent().call_deferred("add_child", R1)
		player.global_position = Vector2(25,40)
		call_deferred("queue_free")


func set_camera_limits(tilemap: TileMap, camera: Camera2D):
	var used_rect = tilemap.get_used_rect()
	var cell_size = Vector2(16, 16)
	
	var top_left = tilemap.map_to_local(used_rect.position)
	var bottom_right = tilemap.map_to_local(used_rect.position + used_rect.size)
	
	camera.limit_left = top_left.x
	camera.limit_top = top_left.y
	camera.limit_right = bottom_right.x - cell_size.x
	camera.limit_bottom = bottom_right.y - cell_size.y


