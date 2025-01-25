@tool
extends BTAction

#todo - starts and stops once you are in TOLERANCE likely intended but want to look at more
#bug - physics glitch when standing on top of a higher place than enemy (faceplants then launches you a great distance) 


@export var target_var: StringName = &"target_pos" #sets/gets target node leave default in the inspector
@export var speed_var: StringName = &"speed" #agent move speed 
@export var tolerance_var: StringName = &"tolerance" # How close agent be to the target
@export var nav_agent_var: StringName = &"nav_agent"
@export var animation_var: StringName = &"animation"

var target: Node3D
var path: Vector3
var direction: Vector3
var speed: float
var tolerance: float
var nav_agent: NavigationAgent3D
var animation: AnimationPlayer


#makes LimboAI window make more sense (renames things in the tree view)
func _generate_name() -> String:
	return "Move Toward ➜ %s" % [LimboUtility.decorate_var(target_var)]


#calls once when starting this leaf
func _enter() -> void:
	target = blackboard.get_var(target_var) #get target_var from Blackboard
	speed = blackboard.get_var(speed_var)
	tolerance = blackboard.get_var(tolerance_var)
	nav_agent = blackboard.get_var(nav_agent_var)
	animation = blackboard.get_var(animation_var)
	
	nav_agent.set_target_position(target.global_position) #set nav_agent to desired position


func _tick(_delta: float) -> Status: #Returns Status SUCCESS RUNNING FAILURE

	agent.velocity = Vector3.ZERO

	path = nav_agent.get_next_path_position() #set nav_agent path to nav map
	direction = agent.global_position.direction_to(path).normalized() 

	agent.velocity = direction * speed
	agent.look_at(Vector3(path.x, 0, path.z), Vector3.UP) #looks at next walk loction
	animation.play("walk_cycle")
	agent.move_and_slide()

	if agent.global_position.distance_to(target.global_position) < tolerance: #how close to target to get
		return SUCCESS

	if (nav_agent.is_navigation_finished()):
		return SUCCESS
	
	if not nav_agent.is_target_reachable():
		return FAILURE
	
	return RUNNING
