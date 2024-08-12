extends State
class_name Follow

@export var enemy : CharacterBody3D

var player: CharacterBody3D

func Enter():
	player = get_node("/root/World/Player")
	
func Physics_Update(delta : float):
	
	var direction = player.global_position - enemy.global_position
	print(direction.length())
	# 11 is right next to playey
	if ((direction.length() < 15) || (enemy.rayCast.is_colliding() && enemy.rayCast.get_collider().is_in_group("players"))):
		move_player_seen(delta)
		print("following: ", direction.length())
		if (enemy.rayCast.is_colliding() && enemy.rayCast.get_collider().is_in_group("players")):
			print("Ray Cast deteced player")
	elif direction.length() > 15:
		print("emitting: ", direction.length())
		Transitioned.emit(self, "idle")
	else:
		stop_moving()
		
func move_player_seen(delta):
	var current_loc = enemy.global_transform.origin
	var next_loc = enemy.nav_agent.get_next_path_position()
	var new_velocity = (next_loc - current_loc).normalized() * enemy.speed

	enemy.nav_agent.set_velocity(new_velocity)
	
	enemy.velocity = enemy.velocity.move_toward(new_velocity, 0.25)
	var desired_rotation_y = atan2(enemy.velocity.x, enemy.velocity.z)
	if enemy.turn_angle_smoothing:
		enemy.rotation.y = lerp_angle(enemy.rotation.y, desired_rotation_y, enemy.turn_speed * delta)
	else:
		enemy.rotation.y = desired_rotation_y

func stop_moving():
	enemy.velocity = Vector3.ZERO
	enemy.nav_agent.set_velocity(Vector3.ZERO)
