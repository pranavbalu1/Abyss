extends Node


const Player = preload("res://scences/Player.tscn")

func _physics_process(_delta):
	pass


func _unhandled_input(event):
	"""if event.is_action_pressed('camera'):
		print(" C Key pressed -> switching cameras")
		if get_viewport().get_camera_3d() == FPSCam:
			GODview.current = true
		else:
			FPSCam.current = true
	"""
	pass
