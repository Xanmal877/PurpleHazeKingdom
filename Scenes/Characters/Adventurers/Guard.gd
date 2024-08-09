extends Adventurer


func _ready():
	super._ready()
	Name = guardNames.pick_random()
	Class = "Guard"
	level = randi_range(3,5)
	StatUpdates()
	await get_tree().create_timer(1).timeout


func LevelUp(Killer, XPvalue, GoldValue):
	super.LevelUp(Killer, XPvalue, GoldValue)
	StatUpdates()


#region Generate Random Position

@export_category("Random Positions")
@export var minX: int = 1180
@export var maxX: int = 2000
@export var minY: int = 500
@export var maxY: int = 1580


func generateRandomPosition():
	var randomX = randf_range(minX, maxX)
	var randomY = randf_range(minY, maxY)
	target = Vector2(randomX, randomY)

#endregion

