extends Node2D


@onready var tamaneko = $Tamaneko
@onready var region_one = $RegionOne


#region The Runtimes

func _ready():
	SetCameraLimits(region_one, tamaneko.camera)

#endregion


#region Camera

func SetCameraLimits(tilemap: TileMap, camera: Camera2D):
	var used_rect = tilemap.get_used_rect()
	var cell_size = Vector2(16, 16)
	
	var top_left = tilemap.map_to_local(used_rect.position)
	var bottom_right = tilemap.map_to_local(used_rect.position + used_rect.size)
	
	camera.limit_left = top_left.x
	camera.limit_top = top_left.y
	camera.limit_right = bottom_right.x - cell_size.x
	camera.limit_bottom = bottom_right.y - cell_size.y


#endregion

