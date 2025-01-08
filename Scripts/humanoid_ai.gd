extends CharacterBody3D

const SPEED = 4.0
const ATTACK_RANGE = 2.0

var player = null 
var state_machine

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

@export var player_path := "/root/3rd_floor/player_0"

func _ready():
	player = get_node(player_path)
#	state_machine = anim_tree.get("parameters/playback")
	
func _physics_process(delta):
	velocity = Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * 10.0)
	move_and_slide()
	
		#var tyrant_location = global_transform.origin
		#var darkrayne0_location = $NavigationAgent3D.get_next_path_position()
		#var new_velocity = (darkrayne0_location - tyrant_location).normalized() * SPEED
		#$NavigationAgent3D.set_velocity(new_velocity)
		#var look_dir = atan2(-velocity.x, -velocity.y)
		#rotation.y = look_dir
