extends Node

@onready var GODview = $GodView


const Player = preload("res://scences/Player.tscn")

func _physics_process(_delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed('camera'):
		print(" C Key pressed -> switching cameras")
		GODview.current = true

