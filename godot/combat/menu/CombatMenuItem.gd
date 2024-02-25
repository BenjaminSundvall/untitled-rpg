class_name Combat_MenuItem extends Button

var action_on_this_button : Combat_Action

func set_action(action : Combat_Action, screen : Combat_CombatScreen):
	action_on_this_button = action
	
	$Margin/Alignment/Text.text = action.action_name
	
	if action.charge_cost == 1:
		$Margin/Alignment/ActionCost.texture = load("res://assets/test/action-cost-1.png")
	elif action.charge_cost == 2:
		$Margin/Alignment/ActionCost.texture = load("res://assets/test/action-cost-2.png")
	elif action.charge_cost == 3:
		$Margin/Alignment/ActionCost.texture = load("res://assets/test/action-cost-3.png")
	elif action.charge_cost == 4:
		$Margin/Alignment/ActionCost.texture = load("res://assets/test/action-cost-4.png")
	
	pressed.connect(screen.queue_action.bind(action))

func lock_if_to_expensive(cost : int):
	disabled = cost < action_on_this_button.charge_cost
