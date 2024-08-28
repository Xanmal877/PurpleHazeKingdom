extends CanvasLayer

@onready var tamaneko = $"../Characters/Tamaneko"
@onready var adventurer_spawn = $"../AdventurerSpawn"
var GM: GameManager = GameManager
var GMSaveState = GM.saveGame
@onready var load_save = $"Screen/Control/HBoxContainer/Load Save"

func _ready():
	if FileAccess.file_exists("user://savegame.data"):
		load_save.disabled = false

func _on_start_over_pressed():
	tamaneko.stats.level = 0
	tamaneko.stats.StatUpdates()
	tamaneko.global_position = adventurer_spawn.global_position
	tamaneko.stats.health = tamaneko.stats.maxHealth
	tamaneko.stats.stamina = tamaneko.stats.maxStamina
	tamaneko.stats.mana = tamaneko.stats.maxMana
	self.hide()


func _on_load_save_pressed():
	if FileAccess.file_exists("user://savegame.data"):
		GMSaveState.LoadGame(tamaneko)
		tamaneko.stats.StatUpdates()
		print("Game Loaded")
		visible = false


func _on_exitgame_pressed():
	get_tree().quit()






