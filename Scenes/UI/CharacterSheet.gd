extends Control

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")
@onready var stats = $Panel/Stats



func _input(event):
	if Input.is_action_just_pressed("Character Sheet"):
		visible = !visible
		if visible:
			tama.inmenu = true
		else:
			tama.inmenu = false

func _process(delta):
	stats.text = ("Level:  " + str(tama.stats.level) +
	"\n" + "Strength:  " + str(tama.stats.Strength) +
	"\n" + "Dexterity:  " + str(tama.stats.Dexterity) +
	"\n" + "Perception:  " + str(tama.stats.Perception) +
	"\n" + "Constitution:  " + str(tama.stats.Constitution) +
	"\n" + "Intelligence:  " + str(tama.stats.Intelligence))
