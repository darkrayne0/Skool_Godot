extends CharacterBody3D


const SPEED = 5.0
const JUMP = 4.5
const SPRINT = 8.0
const FRICTON = 2.0

#player variables
@export var move_speed = 5.0
@export var health = 10
@export var satmina = 10

#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const FOV_CHANGE = 25.0
@export var base_fov = 75.0
@onready var camera = $player_0_camh/player_0_cam

#looks for input
func _input(event):
	if event.is_action_pressed("ui_cancel"): #ui_cancle = esc to quit game
		get_tree().quit()
		
func _physics_process(delta: float) -> void:
	
	camera.fov = base_fov #Game FOV
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta #get_gravity shorter than the alternative

	# Handle jump ui_accept = space checks to see if player is on the floor
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP
		
	if Input.is_action_pressed("sprint"): #sprint button
		sprint(delta)
	else:
		move_speed = SPEED #changes the sprint speed to normal speed
#		camera.fov = lerp(camera.fov, base_fov, delta * 8.0) #fov stuff

	# Get the input direction and handle the movement/deceleration.
	# ui_actions replaced with custom input
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * move_speed, delta * 15.0)
			velocity.z = lerp(velocity.z, direction.z * move_speed, delta * 15.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * move_speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * move_speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * move_speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * move_speed, delta * 3.0)
		
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	move_and_slide()#calls movement function?
	
func _headbob(time) -> Vector3: # temp - headbob function
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func sprint(delta):
	move_speed = SPRINT #changes the normal speed to sprint speed
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT * 2) # todo - fov stuff
	var target_fov = base_fov + FOV_CHANGE * velocity_clamped #fov stuff
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0) #fov stuff
