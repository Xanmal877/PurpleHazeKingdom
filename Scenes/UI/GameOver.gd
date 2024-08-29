extends CanvasLayer

var tama = GameManager.tama
@onready var adventurer_spawn = get_tree().get_first_node_in_group("RespawnMarker")
var GM: GameManager = GameManager
var GMSaveState = GM.saveGame
@onready var load_save = $"Screen/Control/HBoxContainer/Load Save"


func _ready():
	if FileAccess.file_exists("user://savegame.data"):
		load_save.disabled = false


func _on_start_over_pressed():
	tama.stats.level = 0
	tama.stats.StatUpdates()
	tama.global_position = adventurer_spawn.global_position
	tama.stats.health = tama.stats.maxHealth
	tama.stats.stamina = tama.stats.maxStamina
	tama.stats.mana = tama.stats.maxMana
	self.hide()


func _on_load_save_pressed():
	if FileAccess.file_exists("user://savegame.data"):
		GMSaveState.LoadGame(tama)
		tama.stats.StatUpdates()
		print("Game Loaded")
		visible = false


func _on_exitgame_pressed():
	get_tree().quit()






