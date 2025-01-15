extends CharacterBody3D

#player variables
const SPEED = 4.0
const JUMP = 4.5
const SPRINT = 8.0

@export var move_speed = 4.0
@export var health = 10
@export var stamina = 10

#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = .07
var t_bob = 0.0

#fov variables
const FOV_CHANGE = 2.0
@export var base_fov = 75.0
@onready var camera = $player_0_camh/player_0_cam

#state machine variables - LimboAI
var p_state: LimboHSM


func _ready():
	_initate_state_machine()



func _input(event): #looks for input
	if event.is_action_pressed("ui_cancel"): #ui_cancle = esc to quit game
		get_tree().quit()
	elif event.is_action_pressed("space"):
		p_state.dispatch(&"jump_ready")


func _physics_process(delta: float) -> void:
	camera.fov = base_fov #Game FOV
	
	if not is_on_floor(): # Add the gravity.
		velocity += get_gravity() * delta #get_gravity shorter than the alternative
	
	if Input.is_action_pressed("sprint"):
		p_state.dispatch(&"sprint_ready")
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("a", "d", "w", "s") 	# ui_actions replaced with custom input
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
	move_and_slide()

	t_bob += delta * velocity.length() * float(is_on_floor()) 	# Head bob
	camera.transform.origin = _headbob(t_bob)


func _headbob(time) -> Vector3: # temp - headbob function
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos


func _initate_state_machine():
	p_state = LimboHSM.new()
	add_child(p_state)
	
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_ready).call_on_update(idle_update)
	var move_state = LimboState.new().named("move").call_on_enter(move_ready).call_on_update(move_update)
	var jump_state = LimboState.new().named("jump").call_on_enter(jump_ready).call_on_update(jump_update)
	var sprint_state = LimboState.new().named("sprint").call_on_enter(sprint_ready).call_on_update(sprint_update)
	
	p_state.add_child(idle_state)
	p_state.add_child(move_state)
	p_state.add_child(jump_state)
	p_state.add_child(sprint_state)
	
	p_state.add_transition(idle_state, move_state, &"move_ready")
	p_state.add_transition(p_state.ANYSTATE, idle_state, &"state_ended")
	p_state.add_transition(p_state.ANYSTATE, jump_state, &"jump_ready")
	p_state.add_transition(move_state, sprint_state, &"sprint_ready")
	
	p_state.initial_state = idle_state #starting state for player
	p_state.initialize(self)
	p_state.set_active(true)


func idle_ready():
	pass


func idle_update(_delta: float):
	if velocity.length() >= 0.1:
		p_state.dispatch(&"move_ready")


func move_ready():
	move_speed = SPEED


func move_update(_delta: float):
	if velocity.length() <= 0.5:
		p_state.dispatch(&"state_ended")


func jump_ready():
	velocity.y = JUMP


func jump_update(_delta: float):
	if is_on_floor():
		p_state.dispatch(&"state_ended")


func sprint_ready():
	move_speed = SPRINT #changes the normal speed to sprint speed


func sprint_update(delta: float):
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT * 2) #fov stuff
	var target_fov = base_fov + FOV_CHANGE * velocity_clamped #fov stuff
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0) #fov stuff
	if Input.is_action_just_released("sprint"):
		p_state.dispatch(&"state_ended")
