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
	add_transition(idle_state, move_state, &"move_ready")
	add_transition(ANYSTATE, idle_state, &"state_ended")
	add_transition(ANYSTATE, jump_state, &"jump_ready")
	add_transition(ANYSTATE, crouch_state, &"crouch_ready")
	add_transition(move_state, sprint_state, &"sprint_ready")


	initial_state = idle_state #starting state for player
	initialize(player)
	set_active(true)
