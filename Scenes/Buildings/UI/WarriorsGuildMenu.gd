extends Control

@onready var adventurers: Node2D = get_tree().get_first_node_in_group("AdventurerGroup")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Tamaneko")
const WARRIOR = preload("res://Scenes/Characters/Adventurers/Warrior.tscn")


func HireWarriorPressed():
	if player.gold >= 10:
		var npc = WARRIOR.instantiate()
		adventurers.add_child(npc)
		npc.global_position = (player.global_position + Vector2(0,20))
		var inventory = player.inventory
		player.gold -= 10


func _on_close_pressed():
	queue_free()
