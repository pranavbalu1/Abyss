extends CharacterBody3D

const SPEED = 7.0
const JUMP_VELOCITY = 2 

var hp : float = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var neck := $neck 
@onready var camera := $neck/Camera3D


func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _ready():
	camera.current = is_multiplayer_authority() # if not the owner on this client it doesnt enable camera

func _physics_process(delta):
	#disables physics processes if not multiplayer authority
	if is_multiplayer_authority():
		# Add the gravity
		if not is_on_floor():
			velocity.y -= gravity * delta

		if hp != 0:
			# Handle jump.
			if Input.is_action_just_pressed("ui_accept") and is_on_floor():
				velocity.y = JUMP_VELOCITY

			# Get the input direction and handle the movement/deceleration.
			# As good practice, you should replace UI actions with custom gameplay actions.
			var input_dir = Input.get_vector("left", "right", "forward", "back")
			var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				velocity.z = move_toward(velocity.z, 0, SPEED)
		else:
			print("Dead") # TODO : Trigger Death animation here and prefereably implement spectate mode
			pass
			
		move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			neck.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(45))
	
	if event.is_action_pressed("respawn"):
		position = Vector3(0, 1, 0)
	
	if Input.is_action_just_pressed("quit"):
		pass

func _on_death_radius_body_entered(body):
	if body.is_in_group("enemies"):
		pass
		#print("Enemy Nearby")
		#hp -= 1 TODO : uncomment this to make dead work
	pass # Replace with function body.
