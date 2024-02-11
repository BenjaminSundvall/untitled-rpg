class_name Combat_ActionBarLabel extends MarginContainer

func set_action(action : Combat_Action) -> void:
	$Text.text = action.action_name

func set_poisiton(from : float, to : float, of : float) -> void:
	anchor_left = from / of
	anchor_right = to / of

func is_action(action : Combat_Action) -> bool:
	return $Text.text == action.action_name
