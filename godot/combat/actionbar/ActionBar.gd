class_name Combat_ActionBar extends Control

@onready var scene_action_label : PackedScene = load("res://combat/actionbar/ActionBarLabel.tscn")

@onready var action_queue_node : Control = $Bar/ActionQueue
@onready var charge_label : Label = $Markers/ChargeLabel
@onready var charge_bar : ProgressBar = $Bar/ChargeBar
@onready var charge_bar_outline : Panel = $Bar/ChargeBar/AutoComboOutline

var action_queue : Array[Combat_Action] = []
var number_actions : int = 0
var max_actions : int = 4
var actions_full : bool = false

# ------------------------------------------------------------------------------
#    ActionTime control
# ------------------------------------------------------------------------------

func set_progress_to(progress : float) -> void:
	charge_bar.value = progress
	charge_label.text = str(snappedf(progress, 0.1)) + "/" + str(charge_bar.max_value)

# ------------------------------------------------------------------------------
#    Action control
# ------------------------------------------------------------------------------

func set_numb_of_actions(number_of_actions : int) -> void:
	max_actions = number_of_actions
	
	# TODO: Make bar wider as well? Makes it seem longer
	charge_bar.max_value = number_of_actions

func are_actions_full() -> bool:
	return actions_full

func try_add_action(action : Combat_Action) -> bool:
	if action.charge_cost + number_actions <= max_actions:
		add_action(action)
		return true
	return false

func add_action(action : Combat_Action) -> void:
	action_queue.append(action)
	
	_add_label_at(number_actions, action)
	
	number_actions += action.charge_cost
	actions_full = number_actions >= max_actions

func remove_action(action : Combat_Action) -> bool:
	var index_of_action = action_queue.find(action)
	if index_of_action != -1:
		
		# Remove from queue
		action_queue.remove_at(index_of_action)
		number_actions -= action.charge_cost
		actions_full = number_actions >= max_actions
		
		_remove_label_at(index_of_action)
		
		return true
	return false

func remove_all_actions() -> bool:
	if number_actions == 0 and action_queue_node.get_child_count() == 0:
		return false
	
	number_actions = 0
	action_queue = []
	actions_full = number_actions >= max_actions
	
	_remove_all_labels()
	
	return true


# ------------------------------------------------------------------------------
#    Update of Labels [VISUALS]
# ------------------------------------------------------------------------------

func _update_labels():
	for i in len(action_queue):
		pass

func _add_label_at(index_of_label : int, action : Combat_Action):
	var new_label : Combat_ActionBarLabel = scene_action_label.instantiate()
	new_label.set_action(action)
	
	new_label.set_poisiton(index_of_label, index_of_label + action.charge_cost, max_actions)
	
	action_queue_node.add_child(new_label)

func _remove_label_at(index_of_label : int) -> void:
	var action_label = action_queue_node.get_child(index_of_label)
	action_queue_node.remove_child(action_label)
	action_label.queue_free()
	
	for i in range(index_of_label, max_actions):
		# Position labels correctly
		pass

func _remove_all_labels() -> void:
	for action_label in action_queue_node.get_children():
		action_queue_node.remove_child(action_label)
		action_label.queue_free()


# ------------------------------------------------------------------------------
#    Miscellaneous
# ------------------------------------------------------------------------------

func charge_enough_for_actions(charge : float) -> bool:
	return charge >= number_actions

func mark_bar(active : bool):
	if active:
		charge_bar_outline.show()
	else:
		charge_bar_outline.hide()
	
