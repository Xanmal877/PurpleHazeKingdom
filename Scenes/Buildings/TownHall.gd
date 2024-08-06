extends BuildingClass


func _input(event):
	if Input.is_action_just_pressed("Interact"):
		if mouseEntered == true:
			pass


func _on_mouse_entered():
	mouseEntered = true


func _on_mouse_exited():
	mouseEntered = false

