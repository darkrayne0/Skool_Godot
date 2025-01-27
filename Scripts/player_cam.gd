extends CharacterBody3D


#player constants
const SPEED := 4.0 #base player speed
const JUMP := 4.5 #base jump height
const SPRINT := 6.0 #base player sprint speed
const CROUCH := 3.0 #base player crouch speed
const CROUCH_DEPTH := 1.2 #player crouch height
const CROUCH_ORIG := 1.7 #player uncrouch height

#player variables
#@export var health := 10.0
#@export var stamina = 10.0
var direction := Vector3.ZERO
var crouched := false

#head bob variables
const BOB_FREQ := 2.0
const BOB_MOVE := 0.07
var bob_time: float

#fov variables
const FOV_CHANGE := 2.0
@export var base_fov := 75.0
@onready var camera := $player_0_camh/player_0_cam

#state machine variables - LimboAI
@onready var p_state: LimboHSM = $LimboHSM


func _physics_process(delta: float) -> void:
	#print(p_state.get_active_state()) #print

	camera.fov = base_fov #Game FOV

	if not is_on_floor(): # Add the gravity.
		velocity += get_gravity() * delta #get_gravity shorter than the alternative

	#Get the input direction
	var input_dir := Input.get_vector("left", "right", "forward", "backward") 	# ui_actions replaced with custom input
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized() #get vector

	head_bob(delta) #calls headbob function

	move_and_slide() #calls movement physics


func head_bob(delta): #to simulate head bob #todo - find a way to make optional ingame
	bob_time += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = Vector3(
	cos(bob_time * BOB_FREQ * 0.5) * BOB_MOVE,
	sin(bob_time * BOB_FREQ) * BOB_MOVE,
	0)
