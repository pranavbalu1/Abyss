extends Control
class_name NakamaMultiplayer

var session : NakamaSession
var client : NakamaClient
var socket : NakamaSocket #connection to nakama 


# Called when the node enters the scene tree for the first time.
func _ready():
	client = Nakama.create_client("defaultkey", "127.0.0.1", 7350, "http")
	session = await client.authenticate_email_async("test@gmail.com", "password" )
	socket = Nakama.create_socket_from(client)
	
	await socket.connect_async(session)
	socket.connected.connect(onSocketConnected)
	socket.closed.connect(onSockectClosed)
	socket.received_error.connect(onSockectReceivedError)

	socket.received_match_presence.connect(onMatchPresence)
	socket.received_match_state.connect(onMatchState)
	updateUserInfo("test", "testDisplay")# need to have a form that collects info
	var account = await client.get_account_async(session)
	
	$UserAccountText.text = account.user.username
	$DisplayNameText.text = account.user.display_name


func updateUserInfo(username, displayname, avaterurl = "", language = "en", location = "us", timezone ="est"):
	await client.update_account_async(session, username, displayname, avaterurl, language, location, timezone)

#triggers when a socket connects, closes, or throws an error
func onSocketConnected():
	print("Socket connected")
	
func onSockectClosed():
	print("Sockect Closed")
	
func onSockectReceivedError():
	print("Sockect Received Error")

#match presence and match state only usable if using nakama matchmaking system
func onMatchPresence(presence : NakamaRTAPI.MatchPresenceEvent):
	print(presence)

func onMatchState(state : NakamaRTAPI.MatchData):
	print(state)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

