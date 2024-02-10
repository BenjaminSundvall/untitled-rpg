extends Control

# Code taken from https://www.youtube.com/watch?v=e0JLO_5UgQo

@export var address = "127.0.0.1"
@export var port = 8910
var peer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Gets called on server and clients
func peer_connected(id) -> void:
	print("Player connected ", id)
	
# Gets called only from clients    
func peer_disconnected(id) -> void:
	print("Player disconnected ", id)

# Gets called only from clients
func connected_to_server(id) -> void:
	print("Connected to server!")
	send_player_information.rpc_id(1, $LineEdit.text, multiplayer.get_unique_id())

# Gets called only from clients    
func connection_failed(id) -> void:
	print("Connection failed!")

@rpc("any_peer")
func send_player_information(name, id):
	print("Sending player info ", name, id)
	if !GameManager.players.has(id):
		GameManager.players[id] = {
			"name" : name,
			"id" : id,
			"score" : 0
		}
	
	if multiplayer.is_server():
		for i in GameManager.players:
			send_player_information.rpc(GameManager.players[i].name, i)

@rpc("any_peer", "call_local")
func start_game() -> void: 
	var scene = load("res://MultiplayerTest/TestScene.tscn").instantiate()
	get_tree().root.add_child(scene)
	self.hide()

func host_game() -> void:
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port, 2) # Max 2 clients
	if error != OK:
		print("Cannot host: ", error)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # Check wiki on why this compression is used
	
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players...")

func _on_host_button_down() -> void:
	host_game()
	send_player_information($LineEdit.text, multiplayer.get_unique_id())
 
func _on_join_button_down() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER) # Check wiki on why this compression is used
	multiplayer.set_multiplayer_peer(peer)


func _on_start_game_button_down() -> void:
	start_game.rpc()
