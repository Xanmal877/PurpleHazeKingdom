extends CanvasLayer

@onready var tama = get_tree().get_first_node_in_group("Tamaneko")


func _input(event):
	if Input.is_action_just_pressed("QuestLog"):
		visible = !visible



func _on_accept_pressed():
	GameManager.emit_signal("QuestDecision", true)


func _on_decline_pressed():
	GameManager.emit_signal("QuestDecision", false)
	visible = false


func _on_complete_pressed():
	GameManager.QuestCompleted.emit()
