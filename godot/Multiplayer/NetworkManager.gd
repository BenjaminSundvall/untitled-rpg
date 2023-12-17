extends Node

class_name NetworkManager

const DEFAULT_SERVER_IP = "127.0.0.1"
const PORT = 24242

var players : Array[int]

signal player_connect
signal player_disconnect

func _ready():
	players = []
	
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_ok)
	multiplayer.connection_failed.connect(_on_connected_fail)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


# ===============================================
#    Client
# ===============================================

func client_start(address = DEFAULT_SERVER_IP):
	print_net("Client started (don't have a remote ID yet so set to 1)")
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(address, PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer


# ===============================================
#    Server
# ===============================================

func server_start():
	print_net("Server started")
	
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error:
		return error
	multiplayer.multiplayer_peer = peer
	
	add_player(1)

@rpc("any_peer") # [ Any Client -> Server ]
func _report_to_server(player):
	print_net("REPORT SERVER - New player " + str(player))
	
	# If as server decides that client is accepted:
	if true:
		# Report to all clients the validated player data (ok to change)
		_report_to_client.rpc(player)
		
		# Report to new player existing players in session
		_introduce_session_players.rpc_id(
			multiplayer.get_remote_sender_id(), players
			)
		
		# And add players to this one
		add_player(player)
		
		# Else report rejection to the client
	else:
		_report_rejection.rpc_id(multiplayer.get_remote_sender_id())

# ===============================================
#    Event - Any Player
# ===============================================

# When a new player connects to the session (no data shared)
func _on_player_connected(id):
	#print_net("Connected player " + str(id))
	pass

# When a old player disconnects from the session
func _on_player_disconnected(id):
	remove_player(id)
	print_net("Disconnected " + str(id))


# ===============================================
#    Event - Client
# ===============================================

# Succeded on connecting to the server
func _on_connected_ok():
	print_net("Connected to server")
	
	# Create itself, but not save since server will report if everything is ok
	var player_object = multiplayer.get_unique_id()
	
	# Share itself to server
	_report_to_server.rpc_id(1, player_object)

# Client failed to connect to a server
func _on_connected_fail():
	print_net("Connection failed")
	multiplayer.multiplayer_peer = null

# Client got disconnected via server disconnecting 
func _on_server_disconnected():
	print_net("Server disconnect")
	multiplayer.multiplayer_peer = null
	players.clear()

# Server accepted a new player, here it is 
@rpc # [ Server -> All Clients ]
func _report_to_client(player):
	print_net("REPORT CLIENT - New player added to session " + str(player))
	add_player(player)

# Server didn't allow this client to be added
@rpc # [ Server -> This Client ]
func _report_rejection():
	# Awhh... I got rejected
	print_net("REJECTION - I just got rejected")

# Report from server of all existing players in the server
@rpc # [ Server -> This Client ]
func _introduce_session_players(players):
	print_net("INTRODUCE - Server reported players " + str(players))
	add_players(players)


# ===============================================
#    Player Memory
# ===============================================

func add_player(player):
	print_net("Player added   " + str(player))
	players.append(player)
	player_connect.emit(player)
	return player

func add_players(players):
	print_net("Players added  " + str(players))
	self.players.append_array(players)
	
	for player in players:
		player_connect.emit(player)
	
	return players

func remove_player(player):
	print_net("Player removed " + str(player))
	players.erase(player)
	
	player_disconnect.emit(player)
	
	return player

# ===============================================
#    Debug
# ===============================================

func print_net(msg):
	print(("On %10d : Fr %10d :: " % [
		multiplayer.get_unique_id(), multiplayer.get_remote_sender_id()
		]) + msg)
