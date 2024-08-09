class_name BuildingMenu extends Control

@onready var adventurers: Node2D = get_tree().get_first_node_in_group("AdventurerGroup")
@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Tamaneko")


func _on_close_pressed():
	visible = !visible


