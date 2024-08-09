class_name Adventurer extends GameStats


#region Variables

var isincombat: bool = false
var target

@export var NavAgent: NavigationAgent2D

@onready var animation_player = $Animations/AnimationPlayer
@onready var healthbar = $Healthbar
@onready var staminabar = $Staminabar
@onready var manabar = $Manabar
@onready var inventory = $UI/Inventory

#endregion


#region The Runtimes

func _ready():
	requiredXP = (level * 1.5) * 100
	GameManager.connect("MonsterKilled", LevelUp)
	GameManager.connect("AttackMade", TakeDamage)
	StatUpdates()


func _physics_process(_delta):
	Death()
	if isincombat == true:
		velocity = Vector2.ZERO
		speed = 0
	else:
		speed = normalSpeed
		velocity = direction * speed
	move_and_slide()

func _input(event):
	OpenInventory()
	CloseCharacterScreen()

#endregion


#region Combat

@onready var combat = $Timers/Combat

func Detected(area):
	if area.get_owner().is_in_group("enemy"):
		target = area.get_owner()
		NavAgent.target_position = target.global_position
		healthbar.visible = true
		staminabar.visible = true
		manabar.visible = true


func NotDetected(area):
	if area.get_owner().is_in_group("enemy"):
		target = null
		healthbar.visible = false
		staminabar.visible = false
		manabar.visible = false



func InAttackRange(area):
	if area.get_owner().is_in_group("enemy"):
		isincombat = true
		combat.start(0.5)



func NotInAttackRange(area):
	if area.get_owner().is_in_group("enemy"):
		isincombat = false

		combat.stop()
		animation_player.stop()


func TakeDamage(Attacker, Attacked, Damage):
	if Attacked != self:
		return

	health -= Damage
	healthbar.Status()
	staminabar.Status()
	manabar.Status()


func DamageEnemy():
	if target != null:
		animation_player.play("Attack")
		GameManager.emit_signal("AttackMade", self, target, damage)


func Death():
	if health <= 0:
		queue_free()

#endregion


#region Select Character

@onready var inventoryui = $UI/Inventory
var mouseEntered: bool = false
func MouseEntered():
	mouseEntered = true


func MouseExited():
	mouseEntered = false


func CloseCharacterScreen():
	if Input.is_action_just_pressed("Escape"):
		inventoryui.visible = false


#endregion


#region GUI Actions

func OpenInventory():
	if Input.is_action_just_pressed("Interact") and mouseEntered == true:
		inventoryui.visible = !inventoryui.visible

#endregion


#region Pickup Items

func FindItems(area):
	if area.is_in_group("Item"):
		var item = area.get_parent()
		NavAgent.target_position = item.global_position
		inventory.AddItemtoInventory(item.item)
		item.queue_free()

#endregion

