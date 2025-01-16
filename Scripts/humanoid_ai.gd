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

@export var waypoints: Array[Marker3D]

var waypointindex: int

const SPEED = 4


func _ready():
	#currentstate = States.patrol
	nav_agent.set_target_position(waypoints[0].global_position) #sets the NavigationAgent3D target position


func _process(_delta):
	match currentstate:
		States.patrol:
			if (nav_agent.is_navigation_finished()): #makes enemy wait for a time after reaching latest target position
				currentstate = States.waiting
				patroltimer.start()
				return
			var targetpos = nav_agent.get_next_path_position()
			var direction = global_position.direction_to(targetpos)
			velocity = direction * SPEED
			look_at(Vector3(targetpos.x, global_position.y, targetpos.z), Vector3.UP) #looks at next walk loction
			move_and_slide()
			pass
		States.chasing:
			pass
		States.waiting:
			pass
		States.hunting:
			pass


func _on_patrol_timer_timeout() -> void: #on time out it sets the next path for the enemy
	currentstate = States.patrol
	waypointindex += 1 #changes the waypoint array index to the next marker3d
	if waypointindex > waypoints.size() -1: #checks if the next array index is greater than (8 currently) and sets back to 0
		waypointindex = 0
	nav_agent.set_target_position(waypoints[waypointindex].global_position)
