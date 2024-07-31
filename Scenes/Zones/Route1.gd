extends TileMap

@onready var player = get_tree().get_first_node_in_group("Tamaneko")
@onready var autumn = get_tree().get_first_node_in_group("Autumn")
@onready var spawn = $TrellarkSpawn


#region The Runtimes

func _ready():
	if player != null:
		player.camera.enabled = true
		Global.set_camera_limits($".", player.camera)

#endregion


#region Locations

const STONE_EDGE_VILLAGE = preload("res://Scenes/Zones/StoneEdgeVillage.tscn")
func ToVillage(body):
	if body.is_in_group("player"):
		var zone = STONE_EDGE_VILLAGE.instantiate()
		call_deferred("add_sibling", zone)
		player.global_position = Vector2(50,150)
		autumn.global_position = player.global_position + Vector2(10,0)
		call_deferred("queue_free")


func ToTrellarkForest(body):
	if body.is_in_group("player"):
		var zone = Global.TRELLARK_FOREST.instantiate()
		call_deferred("add_sibling", zone)
		player.global_position = Vector2(1033,582)
		autumn.global_position = player.global_position + Vector2(10,0)
		call_deferred("queue_free")


func ToSlimeFields(body):
	if body.is_in_group("player"):
		var zone = Global.SLIME_FIELD.instantiate()
		call_deferred("add_sibling", zone)
		player.global_position = Vector2(30,55)
		autumn.global_position = player.global_position + Vector2(10,0)
		call_deferred("queue_free")


#endregion

