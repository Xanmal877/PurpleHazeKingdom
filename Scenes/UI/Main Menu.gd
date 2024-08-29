extends CanvasLayer

#region  Variables

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")
var GM: GameManager = GameManager
var GMSaveState = GM.saveGame

@onready var new_game = $Menu/VBoxContainer/NewGame
@onready var save_game = $Menu/VBoxContainer/SaveGame
@onready var load_game = $Menu/VBoxContainer/LoadGame
@onready var bananas = $Menu/VBoxContainer/Bananas
@onready var options = $Menu/VBoxContainer/Options
@onready var exit_game = $"Menu/VBoxContainer/Exit Game"

#endregion


#region Runtimes

func _ready():
	new_game.visible = true
	save_game.visible = false
	load_game.visible = false
	if FileAccess.file_exists("user://savegame.data"):
		load_game.visible = true


func _process(_delta):
	if visible:
		tama.healthbar.visible = false
		tama.staminabar.visible = false
		tama.expbar.visible = false
	else:
		tama.healthbar.visible = true
		tama.staminabar.visible = true
		tama.expbar.visible = true

func _input(event):
	if Input.is_action_just_pressed("Escape"):
		visible = !visible
		if visible:
			tama.inmenu = true
		else:
			tama.inmenu = false

#endregion


#region Buttons

func _on_new_game_pressed():
	var file_path = "user://savegame.data"
	if FileAccess.file_exists(file_path):
		DirAccess.remove_absolute(file_path)
	new_game.visible = false
	save_game.visible = true
	load_game.visible = true

	tama.healthbar.visible = true
	tama.staminabar.visible = true

	$"../WorldOverlay".visible = true
	
	visible = false


func _on_save_game_pressed():
	tama.stats.StatUpdates()
	GMSaveState.SaveGame(tama)
	visible = false


func _on_load_game_pressed():
	if FileAccess.file_exists("user://savegame.data"):
		GMSaveState.LoadGame(tama)
		tama.stats.StatUpdates()
		print("Game Loaded")
		visible = false


const OPTIONS_MENU = preload("res://Scenes/UI/OptionsMenu.tscn")
@onready var main_menu = $"."
func _on_options_pressed():
	var menu = OPTIONS_MENU.instantiate()
	main_menu.add_child(menu)


func _on_exit_game_pressed():
	get_tree().quit()

#endregion


#region Bananas

@onready var banana_panel = $Control

func _on_bananas_pressed():
	banana_panel.visible = true


func CloseBananaButton():
	banana_panel.visible = false

#endregion
