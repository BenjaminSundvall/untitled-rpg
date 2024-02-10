extends Node2D

@onready var network_manager : NetworkManager = $MultiplayerManager
@onready var name_input : TextEdit = $NameInput


func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_server():
	network_manager.server_start()

func start_client():
	network_manager.client_start()
	

