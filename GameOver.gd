extends CanvasLayer


func _on_playagain_pressed():
	get_tree().change_scene_to_file("res://World.tscn")


func _on_exitgame_pressed():
	get_tree().quit()
