extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D
@onready var nearby_radius = $DetectionArea
@onready var rayCast = $RayCast3D
@onready var timer = $Timer

var player: CharacterBody3D


var speed: float = 5.0
var turn_speed: int = 10
var player_close: bool = false
var random_position: Vector3 = Vector3(15, 0, 15)
var turn_angle_smoothing: bool = false

# FOV settings
var fov_angle: int = 70 # Total FOV angle (degrees)
var fov_steps: int = 10 # Number of steps to divide FOV
var fov_speed: float = 200.0 # Speed of FOV rotation
var current_fov_angle: float = 0.0



var main_state_machine: LimboHSM

var roam_poi : Array = [
	Vector3(20.0, 1, 20.0),
	Vector3(-10.0, 1, -10.0),
	Vector3(15.0, 1, -20.0),
	Vector3(-25.0, 1, 5.0),
	Vector3(5.0, 1, -25.0),
	Vector3(-20.0, 1, 20.0),
	Vector3(10.0, 1, 15.0),
	Vector3(-5.0, 1, -15.0),
	Vector3(25.0, 1, 10.0),
	Vector3(-15.0, 1, 25.0)
]


func _ready():
	player = get_node("/root/World/Player")

	initiate_state_machine()

func _physics_process(delta):
	move_and_slide()
	
func rotate_raycast(delta):
	current_fov_angle += fov_speed * delta
	if current_fov_angle > fov_angle:
		current_fov_angle = -fov_angle
	var rotation_radians: float = deg_to_rad(current_fov_angle)
	rayCast.rotation.y = rotation_radians
	#print(current_fov_angle)


func initiate_state_machine():
	main_state_machine = LimboHSM.new()
	add_child(main_state_machine)
	
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_start).call_on_update(idle_update)
	var roam_state = LimboState.new().named("roam").call_on_enter(roam_start).call_on_update(roam_update)
	var follow_state = LimboState.new().named("follow").call_on_enter(follow_start).call_on_update(follow_update)
	
	main_state_machine.add_child(idle_state)
	main_state_machine.add_child(roam_state)
	main_state_machine.add_child(follow_state)
	
	main_state_machine.initialize(self)
	main_state_machine.set_active(true)
	
	main_state_machine.initial_state = roam_state
	
	main_state_machine.add_transition(main_state_machine.ANYSTATE, idle_state, &"to_idle")	
	main_state_machine.add_transition(main_state_machine.ANYSTATE, follow_state, &"to_follow")
	main_state_machine.add_transition(main_state_machine.ANYSTATE, roam_state, &"to_roam")
	
		
func idle_start():
	print("idle start")
	timer.start(5)
	pass
	
func idle_update(delta: float):
	
	if timer.time_left == 0:
		main_state_machine.dispatch("to_roam")
		#main_state_machine
		pass
	pass

func roam_start():
	print("roam start")
	timer.start(10)
	pass
	
func roam_update(delta: float):
	move_nav_agent(delta, roam_poi[0])
	if timer.time_left == 0:
		stop_moving()
		main_state_machine.dispatch("to_follow")

func follow_start():
	print("follow start")
	pass
	
func follow_update(delta: float):
	pass

	
func move_nav_agent(delta, target: Vector3):
	nav_agent.target_position = target
	
	var destination: Vector3 = nav_agent.get_next_path_position()
	var local_destination : Vector3= destination - global_position
	var direction = local_destination.normalized()
	
	var target_velocity: Vector3 = direction * speed
	velocity = velocity.move_toward(target_velocity, 0.2)
	nav_agent.set_velocity(velocity)
	
	turn_smoothing(delta)

	var distance_left : float = (nav_agent.target_position - global_position).length()
	print(distance_left)
	if distance_left < 1.2:
		stop_moving()
		roam_poi.shuffle()
		print("roam_poi shuffled")
		
	move_and_slide()
	
func stop_moving():
	velocity = Vector3.ZERO
	nav_agent.set_velocity(Vector3.ZERO)




func roam_target_refresh():
	var shift_roam_target: int = randi_range(-3, 3)
	print(shift_roam_target)
	pass
	
	
func turn_smoothing(delta: float):
	var desired_rotation_y = atan2(velocity.x, velocity.z)
	if turn_angle_smoothing:
		rotation.y = lerp_angle(rotation.y, desired_rotation_y, turn_speed * delta)
	else:
		rotation.y = desired_rotation_y

func _on_navigation_agent_3d_target_reached() :
	print("target reached")
	pass

func _unhandled_input(event: InputEvent):	
	if event.is_action_pressed('position'):
		print(global_transform.origin)
		
	if event.is_action_pressed("smoothing_toggle"):
		turn_angle_smoothing = not turn_angle_smoothing
		print("Smoothing Turn: ", turn_angle_smoothing)
	
	if event.is_action_pressed("respawn"):
		player.position = Vector3(0, 1, 0)
