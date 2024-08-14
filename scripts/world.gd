extends Node

@onready var main_menu = $"CanvasLayer/Main Menu"
@onready var address_entry = $"CanvasLayer/Main Menu/MarginContainer/VBoxContainer/AddressEntry"

const Player = preload("res://scences/Player.tscn")
const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()

func _physics_process(_delta):
	pass


func _on_host_pressed():
	main_menu.hide()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	add_player(multiplayer.get_unique_id())
	


func _on_join_pressed():
	main_menu.hide()
	
	enet_peer.create_client("localhost", PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	
func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

func _unhandled_input(event):
	"""if event.is_action_pressed('camera'):
		print(" C Key pressed -> switching cameras")
		if get_viewport().get_camera_3d() == FPSCam:
			GODview.current = true
		else:
			FPSCam.current = true
	"""
	pass
