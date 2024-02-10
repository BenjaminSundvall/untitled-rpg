extends Node2D

@export var battler : Combat_Battler
@onready var combat_screen : Combat_CombatScreen = $CombatScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	combat_screen.prepare(battler)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("bat_action_1"):
		combat_screen.queue_action(battler.get_actions()[0])
	
	if Input.is_action_just_pressed("bat_action_2"):
		combat_screen.queue_action(battler.get_actions()[1])
	
	if Input.is_action_just_pressed("bat_action_3"):
		combat_screen.queue_action(battler.get_actions()[2])
	
	if Input.is_action_just_pressed("bat_action_4"):
		combat_screen.queue_action(battler.get_actions()[3])
	
	if Input.is_action_just_pressed("bat_activate_combo"):
		var options = battler.get_actions()
		
		var not_full = true
		while not_full:
			var random_action = options[randi() % len(options)]
			combat_screen.queue_action(random_action)
