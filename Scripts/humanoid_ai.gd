extends CharacterBody3D

const SPEED = 4.0
const ATTACK_RANGE = 2.0

var state_machine
var in_game = 2

@onready var nav_agent = $NavigationAgent3D
#@onready var anim_tree = $AnimationTree
@onready var tyrant = $"."
@onready var player = get_node("/root/3rd_floor/player_0")

func _process(delta): #opt - tyrant leans when close
	var target_position = player.transform.origin
	var new_transform = tyrant.transform.looking_at(target_position, Vector3.UP)
	tyrant.transform = tyrant.transform.interpolate_with(new_transform, 10 * delta)

func _physics_process(_delta): # todo - enemy AI
	if Input.is_action_pressed("a"): #temp way to switch beehave states
		in_game = 1
	if Input.is_action_pressed("d"):
		in_game = 2

func chase_player(): #temp function to make movement based off of normal delta move and slide
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	move_and_slide()


func wait_player(): #temp function to do waiting
	velocity = Vector3.ZERO
	#nav_agent.set_target_position(player.global_transform.origin)
	#var next_nav_point = nav_agent.get_next_path_position()
	#velocity = (next_nav_point - global_transform.origin).normalized() * SPEED * 0
	#move_and_slide()

	
func exists_in_game(): #temp - a temp function to get the beehave to work 
	return  in_game == 2
