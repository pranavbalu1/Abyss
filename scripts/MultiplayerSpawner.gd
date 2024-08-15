extends MultiplayerSpawner

@export var playerScene : PackedScene

var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_function = spawn_player
	if is_multiplayer_authority():
		spawn(1)
		multiplayer.peer_connected.connect(spawn_player)
		multiplayer.peer_disconnected.connect(remove_player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func spawn_player(data):
	var player_scene = playerScene.instantiate()
	player_scene.set_multiplayer_authority(data)
	players[data] = player_scene
	return player_scene

func remove_player(data):
	players[data].queue_free()
	players.erase(data)

