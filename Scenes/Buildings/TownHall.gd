extends BuildingClass



func _input(event):
	if Input.is_action_just_pressed("LeftClick"):
		print("Why?")
		if mouseEntered == true:
			print("COOKIES")


func _on_mouse_entered():
	mouseEntered = true
	print(mouseEntered)



func _on_mouse_exited():
	mouseEntered = false
	print(mouseEntered)
