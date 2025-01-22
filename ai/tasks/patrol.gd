@tool
extends BTAction

@export var target_var: StringName = &"target"
var _waypoint: Vector3

func _enter() -> void:
	#agent.waypointindex += 1 #changes the waypoint array index to the next marker3d
	#if agent.waypointindex > agent.waypoints.size() -1: #checks if the next array index is greater than (8 currently) and sets back to 0
		#agent.waypointindex = 0
	var target: CharacterBody3D = blackboard.get_var(target_var, null)
	if is_instance_valid(target):
		# Movement is performed in smaller steps.
		# For each step, we select a new waypoint.
		_select_new_waypoint(_get_desired_position(target))


func _tick(_delta: float) -> Status:
	print(target_var)

	return SUCCESS


func _get_desired_position(target: CharacterBody3D) -> Vector3:
	var side: float = signf(agent.global_position.x - target.global_position.x)
	var desired_pos: Vector3 = target.global_position
	#desired_pos.x += approach_distance * side
	return desired_pos


func _select_new_waypoint(desired_position: Vector3) -> void:
	var distance_vector: Vector3 = desired_position - agent.global_position
	var angle_variation: float = randf_range(-0.2, 0.2)
	_waypoint = agent.global_position
