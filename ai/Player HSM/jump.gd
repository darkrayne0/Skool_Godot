extends LimboState

#agent = the character we are controlling
@onready var cam: Node3D = $"../../player_0_camh"


func _enter() -> void:  #runs once when calling the jump state
	if !agent.crouched:
		agent.velocity.y = agent.JUMP


func _update(delta: float): #runs every frame after _enter finishes
	#handle the movement/deceleration
	agent.velocity.x = move_toward(agent.velocity.x, agent.direction.x * agent.SPEED, delta * 5.0)
	agent.velocity.z = move_toward(agent.velocity.z, agent.direction.z * agent.SPEED, delta * 5.0)

	cam.position.y = lerp(cam.position.y, agent.CROUCH_ORIG, delta * 15) #uncrouch
	if agent.is_on_floor():
		dispatch(&"state_ended")
