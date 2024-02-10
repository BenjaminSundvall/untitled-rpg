class_name Combat_ActionBar extends Control

@onready var scene_action_label : PackedScene = load("res://combat/actionbar/ActionBarLabel.tscn")

@onready var action_queue : GridContainer = $Bar/ActionQueue

@onready var charge_label : Label = $Markers/ChargeLabel
@onready var charge_bar : ProgressBar = $Bar/ChargeBar

# ------------------------------------------------------------------------------
#    ActionTime control [VISUALY ONLY!]
# ------------------------------------------------------------------------------

func set_progress_to(progress : float) -> void:
	charge_bar.value = progress
	charge_label.text = str(snappedf(progress, 0.1)) + "/" + str(charge_bar.max_value)

# ------------------------------------------------------------------------------
#    Action control [VISUALY ONLY!]
# ------------------------------------------------------------------------------

func set_numb_of_actions(number_of_actions : int) -> void:
	action_queue.columns = number_of_actions
	
	# TODO: Make bar wider as well? Makes it seem longer
	charge_bar.max_value = number_of_actions

func are_actions_full() -> bool:
	return action_queue.get_child_count() >= charge_bar.max_value

func add_action(action : Combat_Action) -> void:
	var new_label : Combat_ActionBarLabel = scene_action_label.instantiate()
	new_label.set_action(action)
	
	action_queue.add_child(new_label)

func remove_action(action : Combat_Action) -> bool:
	for action_label : Combat_ActionBarLabel in action_queue.get_children():
		if action_label.is_action(action):
			action_queue.remove_child(action_label)
			action_label.queue_free()
			return true
	return false

func remove_all_actions() -> bool:
	if action_queue.get_child_count() == 0:
		return false
	
	for action_label in action_queue.get_children():
		action_queue.remove_child(action_label)
		action_label.queue_free()
	
	return true

