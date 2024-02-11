extends Node2D

@export var battler : Combat_Battler

@onready var _combat_screen : Combat_CombatScreen = $CombatScreen

# Called when the node enters the scene tree for the first time.
func _ready():
	_combat_screen.prepare(battler)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_combat_screen.update(delta)
	
	if Input.is_action_just_pressed("bat_action_1"):
		_combat_screen.queue_action(battler.get_actions()[0])
	
	if Input.is_action_just_pressed("bat_action_2"):
		_combat_screen.queue_action(battler.get_actions()[1])
	
	if Input.is_action_just_pressed("bat_action_3"):
		_combat_screen.queue_action(battler.get_actions()[2])
	
	if Input.is_action_just_pressed("bat_action_4"):
		_combat_screen.queue_action(battler.get_actions()[3])
	
	if Input.is_action_just_pressed("bat_activate_combo"):
		_combat_screen.commit()
	
	if Input.is_action_just_pressed("bat_deactivate_combo"):
		_combat_screen.undo_commit()
