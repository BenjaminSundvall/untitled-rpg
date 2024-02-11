class_name Combat_Action extends Node2D

@export var action_name : String
@export var charge_cost : int

func _init() -> void:
	#print("WARNING: Initialized action is not implemented!")
	pass

func _to_string() -> String:
	return self.name

func perform_action() -> void:
	#print("WARNING: Performed action is not implemented!")
	pass
