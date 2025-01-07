extends CharacterBody3D


const SPEED = 4.0
var player = null
@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	#if not is_on_floor():
	#	velocity -= get_gravity() * delta #get_gravity shorter than the alternative
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED
	nav_agent.set_velocity(new_velocity)
#	nav_agent.set_target_position(player.global_transform.origin)
#	var next_nav_point = nav_agent.get_next_path_position()
#	velocity = (next_nav_point - player.global_transform.origin).normalized() * SPEED
#	nav_agent.set_velocity(velocity)
	move_and_slide()

#	print(next_nav_point)
