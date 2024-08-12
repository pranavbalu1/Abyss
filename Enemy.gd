extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var nearby_radius = $DetectionArea
@onready var rayCast = $RayCast3D

var player: CharacterBody3D

var speed = 2
var turn_speed = 10
var player_close = false
var random_position = Vector3(15, 0, 15)
var turn_angle_smoothing = false

# FOV settings
var fov_angle = 70 # Total FOV angle (degrees)
var fov_steps = 10 # Number of steps to divide FOV
var fov_speed = 200.0 # Speed of FOV rotation
var current_fov_angle = 0.0

func _ready():
	player = get_node("/root/World/Player")

func _physics_process(delta):
	#stop_moving()
	rotate_raycast(delta)
	#if (rayCast.is_colliding() && rayCast.get_collider().is_in_group("players")):
		#print("Ray Cast Colliding with player")
	move_and_slide()

func rotate_raycast(delta):
	current_fov_angle += fov_speed * delta
	if current_fov_angle > fov_angle:
		current_fov_angle = -fov_angle
	var rotation_radians = deg_to_rad(current_fov_angle)
	rayCast.rotation.y = rotation_radians
	print(current_fov_angle)

func move_player_seen(delta):
	#var space_state = get_world_3d().direct_space_state
	var current_loc = global_transform.origin
	var next_loc = nav_agent.get_next_path_position()
	var new_velocity = (next_loc - current_loc).normalized() * speed
	#var direction_to_next = (next_loc - current_loc).normalized()
	
	nav_agent.set_velocity(new_velocity)
	
	velocity = velocity.move_toward(new_velocity, 0.25)
	var desired_rotation_y = atan2(velocity.x, velocity.z)
	if turn_angle_smoothing:
		rotation.y = lerp_angle(rotation.y, desired_rotation_y, turn_speed * delta)
	else:
		rotation.y = desired_rotation_y
	
	move_and_slide()
	
func move_around_player_unseen(target):
	var current_loc = global_transform.origin
	var next_loc = target
	var new_velocity = (next_loc - current_loc).normalized() * speed
	
	nav_agent.set_velocity(new_velocity)
	if current_loc.distance_to(target) < 0.1:
		stop_moving()
		_on_navigation_agent_3d_target_reached()

	move_and_slide()
	
func stop_moving():
	velocity = Vector3.ZERO
	nav_agent.set_velocity(Vector3.ZERO)

func update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_navigation_agent_3d_target_reached() :
	pass
	#print("target reached")

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()

func _on_detection_area_body_entered(body):
	if body.is_in_group("players"):
		#print("player entered nearby zone")
		player_close = true
		
func _on_detection_area_body_exited(body):
	if body.is_in_group("players"):
		#print("player left neaby zone")
		player_close = false

func _unhandled_input(event: InputEvent):	
	if event.is_action_pressed('position'):
		print(global_transform.origin)
		
	if event.is_action_pressed("smoothing_toggle"):
		turn_angle_smoothing = not turn_angle_smoothing
		print("Smoothing Turn: ", turn_angle_smoothing)
	
	if event.is_action_pressed("respawn"):
		player.position = Vector3(0, 1, 0)
