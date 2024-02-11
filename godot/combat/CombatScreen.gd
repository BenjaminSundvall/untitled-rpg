class_name Combat_CombatScreen extends Node2D

var charge : float = 0
enum ChargeStatus {CHARGING, FULL, PAUSED, DISCHARGING}
var charge_status : ChargeStatus = ChargeStatus.CHARGING

var actions_commited = false

@onready var action_bar : Combat_ActionBar = $ActionBar
@onready var _combat_menu : Combat_Menu = $CombatMenu

# Required 
var battler : Combat_Battler


# ------------------------------------------------------------------------------
#    Prepare
# ------------------------------------------------------------------------------
# Loaded under preperation
var recharge_rate : float
var discharge_rate : float

func prepare(battler_init : Combat_Battler) -> void:
	battler = battler_init
	
	recharge_rate = battler.max_charge / battler.full_recharge_time
	discharge_rate = battler.max_charge / battler.full_discharge_time
	
	action_bar.set_numb_of_actions(battler.max_charge)
	
	_combat_menu.prepare(self)
	_combat_menu.set_options_of_menu(battler.get_actions())


# ------------------------------------------------------------------------------
#    Handle runtime
# ------------------------------------------------------------------------------

func update(delta : float) -> void:
	_update_charge(delta)
	
	if actions_commited and action_bar.charge_enough_for_actions(charge):
		undo_commit()
		action_bar.remove_all_actions()
		charge_status = ChargeStatus.DISCHARGING
	
	action_bar.set_progress_to(charge)

func _update_charge(delta: float) -> void:
	if charge_status == ChargeStatus.CHARGING:
		charge = charge + delta * recharge_rate
		if charge >= battler.max_charge:
			charge = battler.max_charge
			charge_status = ChargeStatus.FULL
		
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
	if not actions_commited and charge_status != ChargeStatus.DISCHARGING: 
		return action_bar.try_add_action(action)
	return false

func commit() -> void:
	if not actions_commited and action_bar.number_actions > 0:
		actions_commited = true
		action_bar.mark_bar(true)

func undo_commit() -> void:
	if actions_commited:
		actions_commited = false
		action_bar.mark_bar(false)
