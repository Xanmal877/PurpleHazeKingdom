extends CanvasLayer

@onready var timer = $Timer
@onready var label = $Label


func _ready():
	get_tree().paused = true
	label.text = "Now Travelling..."
	var tween = get_tree().create_tween()
	tween.tween_property(label, "self_modulate", Color(1,1,1,1), 1)
	timer.wait_time = 1
	timer.start()


func _on_timer_timeout():
	get_tree().paused = false
	queue_free()

