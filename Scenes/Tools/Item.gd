class_name ItemBase extends Node2D

#region Variables

var player
var inrange: bool = false
@onready var inrangelabel = $inrangelabel

@export var item: ItemResource = ItemResource.new()
signal ItemPickedup

#endregion

#
#func _input(_event):
	#PickupItem()


func BodyEntered(body):
	if body.is_in_group("player"):
		player = body
		inrange = true
		print(player, inrange)
		player.inventory.AddItemtoInventory(item)
		queue_free()
		ItemPickedup.emit()
		#inrangelabel.text = "Pickup (E)"
		#inrangelabel.visible = true

#func BodyLeft(body):
	#if body.is_in_group("player"):
		#player = null
		#inrange = false
		#inrangelabel.visible = false

#func PickupItem():
	#if Input.is_action_just_pressed("Interact") and inrange and player != null:
		#print(player, inrange)
		#player.inventory.AddItemtoInventory(item)
		#queue_free()
		#ItemPickedup.emit()


