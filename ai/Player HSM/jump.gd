extends LimboState

#agent = the character we are controlling
@onready var cam: Node3D = $"../../player_0_camh"


func _enter() -> void:  #runs once when calling the jump state
	if !agent.crouched:
		agent.velocity.y = agent.JUMP


func _update(delta: float): #runs every frame after _enter finishes
	cam.position.y = lerp(cam.position.y, agent.CROUCH_ORIG, delta * 15) #uncrouch
	if agent.is_on_floor():
		dispatch(&"state_ended")
