extends Adventurer


func _ready():
	super._ready()
	stats.requiredXP = (stats.level * 1.5) * 100
	stats.name = "Steve"
	stats.Class = "Warrior"
	attributes.Strength = 12
	attributes.Constitution = 12
	attributes.Intelligence = 8
	attributes.Wisdom = 8


