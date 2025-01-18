extends CharacterBody3D

#player constants
const SPEED = 4.0 #base player speed
const JUMP = 4.5 #base jump height
const SPRINT = 8.0 #base player sprint speed
const CROUCH = 3.0 #base player crouch speed
const CROUCH_DEPTH = 1.2 #player crouch height
const CROUCH_ORIG = 1.7 #player uncrouch height

#player variables
#@export var health = 10
#@export var stamina = 10
var direction = Vector3.ZERO
var move_speed: float #player move speed at a given time
var crouched = false


#head bob variables
const BOB_FREQ = 2.0
const BOB_AMP = .07
var t_bob: float

#fov variables
const FOV_CHANGE = 2.0
@export var base_fov = 75.0
@onready var camera = $player_0_camh/player_0_cam

#state machine variables - LimboAI
@onready var p_state: LimboHSM = $LimboHSM
@onready var jump_state: LimboState = $LimboHSM/jump_state
@onready var crouch_state: LimboState = $LimboHSM/crouch_state
@onready var idle_state: LimboState = $LimboHSM/idle_state
@onready var move_state: LimboState = $LimboHSM/move_state
@onready var sprint_state: LimboState = $LimboHSM/sprint_state


func _ready(): #starts the state machine
	_initate_state_machine()


func _input(event): #looks for input
	if event.is_action_pressed("ui_cancel"): #ui_cancle = esc to quit game
		get_tree().quit()
	
	if event.is_action_pressed("crouch"): #allows to change state on button press
		p_state.dispatch(&"crouch_ready")
		
	if event.is_action_pressed("jump"): #allows to change state on button press
		p_state.dispatch(&"jump_ready")
		
	if Input.is_action_pressed("sprint"): #allows to change state on button press
		p_state.dispatch(&"sprint_ready")

func _physics_process(delta: float) -> void:
	camera.fov = base_fov #Game FOV

	if not is_on_floor(): # Add the gravity.
		velocity += get_gravity() * delta #get_gravity shorter than the alternative

	#Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "backward") 	# ui_actions replaced with custom input
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() #get vector
	if is_on_floor():
		if direction: #speed when on the floor
			velocity.x = move_toward(velocity.x, direction.x * move_speed, delta * 15.0)
			velocity.z = move_toward(velocity.z, direction.z * move_speed, delta * 15.0)
		else: #speed when stop moving
			velocity.x = move_toward(velocity.x, direction.x * move_speed, delta * 15.0)
			velocity.z = move_toward(velocity.z, direction.z * move_speed, delta * 15.0)
	else: #speed in the air
		velocity.x = move_toward(velocity.x, direction.x * move_speed, delta * 3.0)
		velocity.z = move_toward(velocity.z, direction.z * move_speed, delta * 3.0)
	move_and_slide()

	t_bob += delta * velocity.length() * float(is_on_floor()) 	# Head bob
	camera.transform.origin = _headbob(t_bob)


func _headbob(time) -> Vector3: #to simulate head bob #todo - find a way to make optional ingame
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func _initate_state_machine(): #LimboAi state machine

	#adding transitions (from state, to state, what to call)
	p_state.add_transition(idle_state, move_state, &"move_ready")
	p_state.add_transition(p_state.ANYSTATE, idle_state, &"state_ended")
	p_state.add_transition(p_state.ANYSTATE, jump_state, &"jump_ready")
	p_state.add_transition(p_state.ANYSTATE, crouch_state, &"crouch_ready")
	p_state.add_transition(move_state, sprint_state, &"sprint_ready")


	p_state.initial_state = idle_state #starting state for player
	p_state.initialize(self)
	p_state.set_active(true)
