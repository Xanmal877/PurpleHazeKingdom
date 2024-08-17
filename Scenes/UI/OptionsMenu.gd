extends Control

@onready var directional_bindings = $"Panel/HBoxContainer/Directional Bindings"

#func _ready():
	#if Tamaneko.fourDirection == false:
		#directional_bindings.text = "OFF"
	#elif Tamaneko.fourDirection == true:
		#directional_bindings.text = "ON"


func _on_directional_bindings_pressed():
	if Tamaneko.fourDirection == false:
		directional_bindings.text = "OFF"
		Tamaneko.fourDirection = true
	elif Tamaneko.fourDirection == true:
		directional_bindings.text = "ON"
		Tamaneko.fourDirection = false
	print(Tamaneko.fourDirection)


func _on_exitmenu_pressed():
	queue_free()
