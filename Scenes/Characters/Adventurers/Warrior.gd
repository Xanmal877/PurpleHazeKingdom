extends Adventurer


func _ready():
	super._ready()
	Name = adventurerNames.pick_random()
	Class = "Warrior"
	StatUpdates()
	await get_tree().create_timer(1).timeout


func LevelUp(Killer, XPvalue, GoldValue):
	super.LevelUp(Killer, XPvalue, GoldValue)
	Strength += 2
	Constitution += 2
	StatUpdates()


