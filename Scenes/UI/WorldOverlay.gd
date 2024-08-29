extends CanvasLayer


func _process(delta):
	GameTimer(time_label)


#region GameTime

var time: float = 0
@onready var time_label = $TimeLabel
func GameTimer(timeLabel: Label):
	time += 0.02
	var hours = int(time) / 3600
	var minutes = (int(time) % 3600) / 60
	var seconds = int(time) % 60

	timeLabel.text = "Time: %02d:%02d:%02d" % [hours, minutes, seconds]

#endregion



