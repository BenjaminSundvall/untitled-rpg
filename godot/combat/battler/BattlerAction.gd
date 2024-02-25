class_name Combat_Action extends Node2D

@export var action_name : String
@export var charge_cost : int

enum Target {ONE_ENEMY, ALL_ENEMIES, ONE_FRIEND, ALL_FRIENDS}
@export var target : Target = Target.ONE_ENEMY

enum Effect {HARM, HEAL}
@export var effect : Effect = Effect.HARM
@export var effect_strength : int = 40

func _init() -> void:
	#print("WARNING: Initialized action is not implemented!")
	pass

func _to_string() -> String:
	return self.name

func perform_action() -> void:
	#print("WARNING: Performed action is not implemented!")
	pass
