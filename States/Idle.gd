extends State
class_name EnemyIdle

@export var enemy : CharacterBody3D

var player : CharacterBody3D
var move_dir : Vector3
var wander_time: float

func roam():
	move_dir.x = randf_range(-1, 1)
	move_dir.z = randf_range(-1, 1)
	wander_time = randf_range(1, 3)
	
func Enter():
	player = get_node("/root/World/Player")
	#roam()

func Update(delta : float):
		if wander_time > 0:
				wander_time -= delta
		else:
			#roam()
			pass

func Physics_Update(delta : float):
		if enemy:
			enemy.velocity = move_dir * enemy.speed
		
		var direction = player.global_position - enemy.global_position
		if (enemy.rayCast.is_colliding() && enemy.rayCast.get_collider().is_in_group("players")):
			Transitioned.emit(self, "Follow")
			#(direction.length() < 15) || 
