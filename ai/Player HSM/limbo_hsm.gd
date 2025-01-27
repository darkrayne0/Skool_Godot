extends LimboHSM

#who we are controlling
@export var player: CharacterBody3D

#state machine variables - LimboAI
@onready var crouch_state: LimboState = $crouch_state
@onready var jump_state: LimboState = $jump_state
@onready var idle_state: LimboState = $idle_state
@onready var move_state: LimboState = $move_state
@onready var sprint_state: LimboState = $sprint_state


func _ready(): #starts the state machine
	initialize(player)

	add_transition(idle_state, move_state, &"move_ready")
	add_transition(ANYSTATE, idle_state, &"state_ended")
	add_transition(ANYSTATE, jump_state, &"jump_ready")
	add_transition(ANYSTATE, crouch_state, &"crouch_ready")
	add_transition(move_state, sprint_state, &"sprint_ready")

	initial_state = idle_state #starting state for player

	set_active(true)


func _input(event): #looks for input
	if event.is_action_pressed("ui_cancel"): #ui_cancle = esc to quit game
		get_tree().quit()

	if event.is_action_pressed("crouch"): #allows to change state on button press
		dispatch(&"crouch_ready")

	if event.is_action_pressed("jump"): #allows to change state on button press
		dispatch(&"jump_ready")

	if Input.is_action_pressed("sprint"): #allows to change state on button press
		dispatch(&"sprint_ready")
