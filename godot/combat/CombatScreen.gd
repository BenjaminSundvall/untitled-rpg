class_name Combat_CombatScreen extends Node2D

### Charge trackers ###
var charge : float = 0
enum ChargeStatus {CHARGING, FULL, PAUSED, DISCHARGING}
var charge_status : ChargeStatus = ChargeStatus.CHARGING
var charge_discharge_to : float

var actions_commited = false

### Child accesors ###
@onready var action_bar : Combat_ActionBar = $ActionBar
@onready var _combat_menu : Combat_Menu = $CombatMenu

### Required ###
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
	
	_update_menu_accessibility()


# ------------------------------------------------------------------------------
#    Handle runtime
# ------------------------------------------------------------------------------

func update(delta : float) -> void:
	_update_charge(delta)
	
	var charge_overflow = action_bar.charge_enough_for_actions(charge)
	if actions_commited and charge_overflow >= 0:
		undo_commit()
		charge_discharge_to = charge_overflow
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
		charge = max(charge - delta * discharge_rate, charge_discharge_to)
		if charge == charge_discharge_to:
			_update_menu_accessibility()
			charge_status = ChargeStatus.CHARGING


# ------------------------------------------------------------------------------
#    Action handling
# ------------------------------------------------------------------------------

func queue_action(action : Combat_Action) -> bool:
	if not actions_commited and charge_status != ChargeStatus.DISCHARGING: 
		var successfuly_added = action_bar.try_add_action(action)
		
		if successfuly_added:
			_update_menu_accessibility()
			return true
		 
	return false

func commit() -> void:
	if not actions_commited and action_bar.number_actions > 0:
		actions_commited = true
		action_bar.mark_bar(true)
		_lock_menu_accessibility()

func undo_commit() -> void:
	if actions_commited:
		actions_commited = false
		action_bar.mark_bar(false)
		_update_menu_accessibility()


# ------------------------------------------------------------------------------
#    Menu handling
# ------------------------------------------------------------------------------

func _update_menu_accessibility() -> void:
	_combat_menu.lock_options_above(battler.max_charge - action_bar.number_actions)

func _lock_menu_accessibility() -> void:
	_combat_menu.lock_options_above(0)
