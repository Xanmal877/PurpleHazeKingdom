extends TileMap


#region The Variables

@onready var region_one = $"."
@onready var tamaneko = $"../Tamaneko"
@onready var zone_text = $CanvasLayer/ZoneText

const BLUESLIME = preload("res://Scenes/Characters/Blueslime.tscn")

#endregion


#region Zone Entered

#region RouteOne

@onready var r1slimes = $RouteOne/NPC/Slimes
@onready var r1Markers = $RouteOne/NPC/SlimeMarkers

func RouteOneEntered(body):
	if body.is_in_group("Tamaneko"):
		for s in r1Markers.get_children():
			var slime = BLUESLIME.instantiate()
			r1slimes.call_deferred("add_child", slime)
			slime.global_position = s.global_position
		zone_text.visible = true
		zone_text.text = "Route One"
		await get_tree().create_timer(3).timeout
		zone_text.visible = false


func RouteOneExited(_body):
	for slime in r1slimes.get_children():
		slime.queue_free()

#endregion


#region Slime Fields

@onready var sfMarkers = $SlimeFields/NPC/SlimeMarkers
@onready var sfSlimes = $SlimeFields/NPC/Slimes
func SlimeFieldEntered(body):
	if body.is_in_group("Tamaneko"):
		for s in sfMarkers.get_children():
			var slime = BLUESLIME.instantiate()
			sfSlimes.call_deferred("add_child", slime)
			slime.global_position = s.global_position
		zone_text.visible = true
		zone_text.text = "Slime Fields"
		await get_tree().create_timer(3).timeout
		zone_text.visible = false


func SlimeFieldExited(_body):
	for slime in sfSlimes.get_children():
		slime.queue_free()

#endregion


#region Trellark Forest

@onready var TFMarkers = $Trellark/NPC/SlimeMarkers
@onready var TFslimes = $Trellark/NPC/Slimes

func TrellarkForestEntered(body):
	if body.is_in_group("Tamaneko"):
		for s in TFMarkers.get_children():
			var slime = BLUESLIME.instantiate()
			TFslimes.call_deferred("add_child", slime)
			slime.global_position = s.global_position
		zone_text.visible = true
		zone_text.text = "Slime Fields"
		await get_tree().create_timer(3).timeout
		zone_text.visible = false


func TrellarkForestExited(_body):
	for slime in TFslimes.get_children():
		slime.queue_free()


#endregion

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

