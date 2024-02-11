class_name Combat_MenuItem extends Button

func set_action(action : Combat_Action, screen : Combat_CombatScreen):
	
	$Margin/Text.text = action.action_name
	
	pressed.connect(screen.queue_action.bind(action))
