extends Node2D

enum ChargeStatus {CHARGING, PAUSED, DISCHARGING}

@export var max_charge : int = 4
@export var full_recharge_time : float = 4.2
@export var full_discharge_time : float = 1.0

var recharge_rate : float = max_charge / full_recharge_time
var discharge_rate : float = max_charge / full_discharge_time
var charge : float = 0
var charge_status : ChargeStatus = ChargeStatus.CHARGING

var action_queue : Array[Action] = []
var auto_combo : bool = false

const ActionLabel : PackedScene = preload("res://ActionLabel.tscn")
#const FireballAction = preload("res://actions/FireballAction.gd")
#const StrikeAction = preload("res://actions/StrikeAction.gd")
#const HealAction = preload("res://actions/HealAction.gd")
#@export var action_library : Array[Action] = []

var action_1 : Action
var action_2 : Action
var action_3 : Action
var action_4 : Action

func _ready() -> void:
    $ChargeBar.max_value = max_charge
    $ActionQueue.columns = max_charge
    action_1 = load("res://actions/StrikeAction.gd").new()
    action_2 = load("res://actions/BlockAction.gd").new()
    action_3 = load("res://actions/HealAction.gd").new()
    action_4 = load("res://actions/FireballAction.gd").new()


func _process(delta: float) -> void:
    if charge_status == ChargeStatus.CHARGING:
        charge = min(charge + delta * recharge_rate, max_charge)
    elif charge_status == ChargeStatus.DISCHARGING:
        charge = max(charge - delta * discharge_rate, 0)
        if charge == 0:
            charge_status = ChargeStatus.CHARGING

    handle_input()
    if auto_combo and charge >= len(action_queue):
        activate_combo()
    update_ui()


func handle_input() -> void:
    var charge_cost : int = 1
    if Input.is_action_just_pressed("bat_action_1") and len(action_queue) < max_charge:
        queue_action(action_1)

    if Input.is_action_just_pressed("bat_action_2") and len(action_queue) < max_charge:
        queue_action(action_2)

    if Input.is_action_just_pressed("bat_action_3") and len(action_queue) < max_charge:
        queue_action(action_3)

    if Input.is_action_just_pressed("bat_action_4") and len(action_queue) < max_charge:
        queue_action(action_4)

    if Input.is_action_just_pressed("bat_activate_combo") and charge >= charge_cost:
        set_auto_combo(!auto_combo)
        

func update_ui() -> void:
    $ChargeBar.value = charge
    $ChargeBar/ChargeLabel.text = str(snappedf(charge, 0.1)) + "/" + str(max_charge)


func activate_combo() -> void:
    var actions : int = len(action_queue)

    if actions > charge:
        print("Not enough charge!")
        return

    print("Activating combo with ", actions, " actions...")
    for action in action_queue:
        print("Casting ", action)

    #charge -= actions
    charge_status = ChargeStatus.DISCHARGING
    set_auto_combo(false)
    
    action_queue.clear()
    for child in $ActionQueue.get_children():
        child.queue_free()


func queue_action(action : Action) -> void:
    print("Queueing ", str(action))
    action_queue.append(action)
    var action_label : Label = ActionLabel.instantiate()
    action_label.text = str(action)
    $ActionQueue.add_child(action_label)

func set_auto_combo(enabled : bool):
    auto_combo = enabled
    $ChargeBar/AutoComboOutline.visible = auto_combo
    print("Auto combo: ", auto_combo)
    
