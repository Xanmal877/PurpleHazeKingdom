extends CanvasLayer

@onready var timer = $Timer
@onready var progress_bar = $ProgressBar


func _ready():
	get_tree().paused = true
	timer.wait_time = randi_range(1,5)
	timer.start()


func _process(delta):
	progress_bar.max_value = timer.wait_time
	progress_bar.value = timer.time_left


func _on_timer_timeout():
	get_tree().paused = false
	queue_free()
