class_name Combat_Battler extends Node2D

# Actions
@onready var action_list = $ActionList

# Action Execution
@export var max_charge : int = 4
@export var full_recharge_time : float = 4.2
@export var full_discharge_time : float = 1.0


func get_actions() -> Array[Combat_Action]:
	var actions : Array[Combat_Action] = []
	for action : Combat_Action in action_list.get_children():
		actions.append(action)
	
	return actions
