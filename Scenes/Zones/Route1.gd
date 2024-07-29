extends TileMap


@onready var player = get_tree().get_first_node_in_group("player")
@onready var spawn = $TrellarkSpawn


#region The Runtimes

func _ready():
	if player != null:
		player.camera.enabled = true
		Global.set_camera_limits($".", player.camera)


#endregion

const STONE_EDGE_VILLAGE = preload("res://Scenes/Zones/StoneEdgeVillage.tscn")
func ToVillage(body):
	if body.is_in_group("player"):
		var zone = STONE_EDGE_VILLAGE.instantiate()
		call_deferred("add_sibling", zone)
		player.global_position = Vector2(50,150)
		call_deferred("queue_free")


func ToTrellarkForest(body):
	if body.is_in_group("player"):
		var zone = Global.TRELLARK_FOREST.instantiate()
		call_deferred("add_sibling", zone)
		player.global_position = Vector2(1033,582)
		call_deferred("queue_free")


func ToSlimeFields(body):
	if body.is_in_group("player"):
		var zone = Global.SLIME_FIELD.instantiate()
		call_deferred("add_sibling", zone)
		player.global_position = Vector2(30,55)
		call_deferred("queue_free")


