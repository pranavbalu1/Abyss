extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_environment("SteamAppID", str(480))
	OS.set_environment("SteamGameID", str(480))
	Steam.steamInitEx()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Steam.run_callbacks()
