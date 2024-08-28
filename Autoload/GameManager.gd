extends Node


#region Variables, Constants and Signals

#region Characters

const TAMANEKO = preload("res://Scenes/Characters/Fuyuki/Tamaneko.tscn")
const AIAUTUMN = preload("res://Scenes/Characters/Autumn/AIAutumn.tscn")

const SLIME = preload("res://Scenes/Characters/BlueSlime/Slime.tscn")

#endregion


var time: float = 0
var saveGame: SaveSystem = SaveSystem.new()

signal AttackMade(Attacker:CharacterBody2D, Attacked:CharacterBody2D, Damage)
signal MonsterKilled(Killed, XPValue: int, GoldValue: int)

#endregion


#region Camera and Timer

func SetCameraLimits(tilemap: TileMap, camera: Camera2D):
	var used_rect = tilemap.get_used_rect()
	var cell_size = Vector2(16, 16)
	
	var top_left = tilemap.map_to_local(used_rect.position)
	var bottom_right = tilemap.map_to_local(used_rect.position + used_rect.size)
	
	camera.limit_left = top_left.x
	camera.limit_top = top_left.y
	camera.limit_right = bottom_right.x - cell_size.x
	camera.limit_bottom = bottom_right.y - cell_size.y


func GameTimer(timeLabel: Label):
	time += 0.02
	var hours = int(time) / 3600
	var minutes = (int(time) % 3600) / 60
	var seconds = int(time) % 60

	timeLabel.text = "Time: %02d:%02d:%02d" % [hours, minutes, seconds]


#endregion

