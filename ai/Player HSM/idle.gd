extends LimboState

#agent = the character we are controlling
@onready var cam: Node3D = $"../../player_0_camh"
@onready var stand_collision: CollisionShape3D = $"../../player_0_collision"
@onready var crouch_collision: CollisionShape3D = $"../../Crouch_Collision"


func _enter() -> void: #runs once when calling the idle state
	agent.crouched = false
	stand_collision.disabled = false
	crouch_collision.disabled = true

func _update(delta: float): #runs every frame after _enter finishes
	#handle the movement/deceleration
	agent.velocity.x = move_toward(agent.velocity.x, agent.direction.x * agent.SPEED, delta * 15.0)
	agent.velocity.z = move_toward(agent.velocity.z, agent.direction.z * agent.SPEED, delta * 15.0)

	cam.position.y = lerp(cam.position.y, agent.CROUCH_ORIG, delta * 15) #uncrouch
	if agent.direction != Vector3.ZERO: #checks if you are moving then call moving state
		dispatch(&"move_ready")
