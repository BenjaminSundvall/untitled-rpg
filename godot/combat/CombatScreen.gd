class_name Combat_CombatScreen extends Node2D


var charge : float = 0
enum ChargeStatus {CHARGING, PAUSED, DISCHARGING}
var charge_status : ChargeStatus = ChargeStatus.CHARGING

@onready var action_bar : Combat_ActionBar = $ActionBar

# Required 
var battler : Combat_Battler


# ------------------------------------------------------------------------------
#    Prepare
# ------------------------------------------------------------------------------
# Loaded under preperation
var recharge_rate : float
var discharge_rate : float

func prepare(battler : Combat_Battler) -> void:
	recharge_rate = battler.max_charge / battler.full_recharge_time
	discharge_rate = battler.max_charge / battler.full_discharge_time
	
	action_bar.set_numb_of_actions(battler.max_charge)

# ------------------------------------------------------------------------------
#    Handle runtime
# ------------------------------------------------------------------------------

func _update_charge(delta: float) -> void:
	if charge_status == ChargeStatus.CHARGING:
		charge = min(charge + delta * recharge_rate, battler.max_charge)
	elif charge_status == ChargeStatus.DISCHARGING:
		charge = max(charge - delta * discharge_rate, 0)
		if charge == 0:
			charge_status = ChargeStatus.CHARGING


# ------------------------------------------------------------------------------
#    Action handling
# ------------------------------------------------------------------------------


func action_handle() -> void:
	# TODO: All input handling should be done through here
	
	# There is a lot of ideas how good input to action handling should be made
	# but for generality/modularity, each action or set of actions should be 
	# mapped fixedly somehow, so input behaviour is expectable.
	
	# Note that 'queue_action()' is made to actually chose actions but this is
	# hijacked in testing.
	
	pass

func queue_action(action : Combat_Action) -> bool:
	if action_bar.are_actions_full():
		return false
	action_bar.add_action(action)
	return true

