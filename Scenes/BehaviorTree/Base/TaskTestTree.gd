class_name TaskTestTree extends Node



@export var user: CharacterBody2D
var direction: Vector2
var target = null

@export var time: float

func CanUsePhysics(_state):
	return false


func UseActionPhysics(_state):
	pass

