class_name RegenerationSkill extends Node

@export var user: CharacterBody2D

var Htimerscene: Timer = Timer.new()
var Stimerscene: Timer = Timer.new()
var Mtimerscene: Timer = Timer.new()


func _ready():
	add_child(Htimerscene)
	add_child(Stimerscene)
	add_child(Mtimerscene)
	Htimerscene.wait_time = 3
	Stimerscene.wait_time = 3
	Mtimerscene.wait_time = 3
	Htimerscene.autostart = true
	Stimerscene.autostart = true
	Mtimerscene.autostart = true
	Htimerscene.start()
	Stimerscene.start()
	Mtimerscene.start()




func RegenerateHealth():
	print("1")
	await Htimerscene.timeout
	print("2")
	if user.stats.health < user.stats.maxHealth:
		user.stats.health += user.stats.healthRegen


func RegenerateStamina():
	await Stimerscene.timeout
	if user.stats.stamina < user.stats.maxStamina:
		user.stats.stamina += user.stats.staminaRegen


func RegenerateMana():
	await Mtimerscene.timeout
	if user.stats.stamina < user.stats.maxStamina:
		user.stats.stamina += user.stats.staminaRegen


