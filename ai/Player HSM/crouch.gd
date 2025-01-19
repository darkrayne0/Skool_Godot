extends LimboState

#agent = the character we are controlling
@onready var cam: Node3D = $"../../player_0_camh"
@onready var stand_collision: CollisionShape3D = $"../../player_0_collision"
@onready var crouch_collision: CollisionShape3D = $"../../Crouch_Collision"
@onready var crouch_check: RayCast3D = $"../../player_0_camh/crouch_check"


func _enter() -> void: #runs once when calling the crouch state
	agent.move_speed = agent.CROUCH #changes the normal speed to sprint speed
	agent.crouched = true
	stand_collision.disabled = true
	crouch_collision.disabled = false

	
func _update(delta: float): #runs every frame after _enter finishes
	if agent.is_on_floor():
		cam.position.y = lerp(cam.position.y, agent.CROUCH_DEPTH, delta * 15) #crouch
	if Input.is_action_just_released("crouch"):
		agent.crouched = false
	if !agent.crouched and !crouch_check.is_colliding():
		dispatch(&"state_ended")
