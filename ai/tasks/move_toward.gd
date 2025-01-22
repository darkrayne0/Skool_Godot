@tool
extends BTAction

#todo - figure out how to handle speed differences CHASE, SPEED etc
#could use blackboard, could maybe use agent script??? idk
#todo - starts and stops once you are in TOLERANCE likely intended but want to look at more

@export var target_var: StringName = &"target_pos" #sets/gets target node leave default in the inspector

var target: Node3D
var desired_pos: Vector3
var path: Vector3
var direction: Vector3

const TOLERANCE := 5.0 # How close agent be to the target


#makes LimboAI window make more sense (renames things in the tree view)
func _generate_name() -> String:
	return "Move Toward %s" % [LimboUtility.decorate_var(target_var)]


#calls once when starting this leaf
func _enter() -> void:
	target = blackboard.get_var(target_var) #get target_var from Blackboard


func _tick(_delta: float) -> Status: #Returns Status SUCCESS RUNNING FAILURE
	desired_pos = target.global_transform.origin #get target Vector3
	path = agent.nav_agent.get_next_path_position() #set nav_agent path to nav map
	direction = agent.global_position.direction_to(path) 
	
	agent.nav_agent.set_target_position(desired_pos)#set nav_agent to desired position
	agent.velocity = direction * agent.SPEED
	agent.look_at(Vector3(desired_pos.x, 0, desired_pos.z), Vector3.UP) #looks at next walk loction
	agent.animation.play("walk_cycle")
	agent.move_and_slide()
	
	if agent.global_position.distance_to(desired_pos) < TOLERANCE: #how close to target to get #desired_pos
		return SUCCESS

	if (agent.nav_agent.is_navigation_finished()):
		return SUCCESS
	else:
		return RUNNING
