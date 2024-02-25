class_name Combat_Menu extends Control

var _combat_screen : Combat_CombatScreen

@onready var _packed_menu_item : PackedScene = load("res://combat/menu/CombatMenuItem.tscn")

@onready var _node_item_container : VBoxContainer = $List/Items


func prepare(combat_screen : Combat_CombatScreen):
	_combat_screen = combat_screen
	
	var node_button : Button = $List/CommitButton
	node_button.pressed.connect(combat_screen.commit)


func set_options_of_menu(actions : Array[Combat_Action]):
	for child in _node_item_container.get_children():
		_node_item_container.remove_child(child)
		child.queue_free()
	
	for action : Combat_Action in actions:
		var node_action : Combat_MenuItem = _packed_menu_item.instantiate()
		node_action.set_action(action, _combat_screen)
		_node_item_container.add_child(node_action)


func lock_options_above(cost : int) -> void:
	for child : Combat_MenuItem in _node_item_container.get_children():
		child.lock_if_to_expensive(cost)

