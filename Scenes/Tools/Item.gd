class_name ItemBase extends Node2D

#region Variables

var player
var ally
var inrange: bool = false
@onready var inrangelabel = $inrangelabel

@export var item: ItemResource = ItemResource.new()
signal ItemPickedup

#endregion


func _input(_event):
	PickupItem()


func BodyEntered(body):
	if body.is_in_group("player") or body.is_in_group("ally"):
		inrange = true
		inrangelabel.visible = true
	if body.is_in_group("player"):
		player = body
	if body.is_in_group("ally"):
		ally = body

func BodyLeft(body):
	if body.is_in_group("player") or body.is_in_group("ally"):
		inrange = false
		inrangelabel.visible = false


func PickupItem():
	if Input.is_action_just_pressed("Interact") and inrange == true:
		player.inventory.AddItemtoInventory(item)
		queue_free()
		ItemPickedup.emit()
