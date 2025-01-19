extends CharacterBody3D

enum States{
	patrol,
	hunting,
	chasing,
	waiting
}

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var currentstate: States = States.patrol
@onready var patroltimer: Timer = $PatrolTimer
@onready var player = get_tree().get_nodes_in_group("player")[0]


@export var waypoints: Array[Marker3D]

var waypointindex: int
var seeplayer: bool
var hearplayer: bool  

const SPEED = 4
const CHASE = 6


func _ready():
	#currentstate = States.patrol
	nav_agent.set_target_position(waypoints[0].global_position) #sets the NavigationAgent3D target position


func _process(delta):
	match currentstate:
		States.patrol:
			if (nav_agent.is_navigation_finished()): #makes enemy wait for a time after reaching latest target position
				currentstate = States.waiting
				patroltimer.start()
			move_toward_point(delta, SPEED)
			if (seeplayer):
				currentstate = States.chasing
			if (hearplayer):
				check_for_player()

		States.chasing:
			if (nav_agent.is_navigation_finished()): #makes enemy wait for a time after reaching latest target position
				patroltimer.start()
				currentstate = States.waiting
			nav_agent.set_target_position(player.global_position)
			move_toward_point(delta, CHASE)
			patroltimer.start()

		States.waiting:
			if (seeplayer):
				currentstate = States.chasing
			if (hearplayer):
				check_for_player()

		States.hunting:
			if (nav_agent.is_navigation_finished()): #makes enemy wait for a time after reaching latest target position
				patroltimer.start()
				currentstate = States.waiting
			move_toward_point(delta, SPEED)
			if (seeplayer):
				currentstate = States.chasing
			if (hearplayer):
				check_for_player()
			patroltimer.start()

func move_toward_point(_delta, speed):
	var targetpos = nav_agent.get_next_path_position()
	var direction = global_position.direction_to(targetpos)
	velocity = direction * speed
	look_at(Vector3(targetpos.x, global_position.y, targetpos.z), Vector3.UP) #looks at next walk loction
	move_and_slide()


func check_for_player():
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create($head.global_position, player.get_node("player_0_camh/player_0_cam").global_position, 8, [self]))
	if result.size() > 0:
		if (result["collider"].is_in_group("player")):
			if (hearplayer):
				if player.p_state.get_active_state() != player.p_state.crouch_state: #(result["collider"]).crouched == false:
					currentstate = States.hunting
					nav_agent.set_target_position(player.global_position)
			if (seeplayer):
				currentstate = States.chasing


func _on_patrol_timer_timeout() -> void: #on time out it sets the next path for the enemy
	currentstate = States.patrol
	waypointindex += 1 #changes the waypoint array index to the next marker3d
	if waypointindex > waypoints.size() -1: #checks if the next array index is greater than (8 currently) and sets back to 0
		waypointindex = 0
	nav_agent.set_target_position(waypoints[waypointindex].global_position)


func _on_hearing_body_entered(_body: Node3D) -> void:
	hearplayer = true


func _on_hearing_body_exited(_body: Node3D) -> void:
	hearplayer = false


func _on_vision_body_entered(_body: Node3D) -> void:
	seeplayer = true


func _on_vision_body_exited(_body: Node3D) -> void:
	seeplayer = false
