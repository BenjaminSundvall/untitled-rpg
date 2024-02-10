class_name Combat_ActionBarLabel extends MarginContainer

func set_action(action : Combat_Action) -> void:
	$Text.text = action.action_name

func is_action(action : Combat_Action) -> bool:
	return $Text.text == action.action_name
