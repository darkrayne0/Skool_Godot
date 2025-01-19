extends LimboState

#agent = the character we are controlling
@onready var cam: Node3D = $"../../player_0_camh"


func _enter() -> void: #runs once when calling the move state
	pass


func _update(delta: float): #runs every frame after _enter finishes
	cam.position.y = lerp(cam.position.y, agent.CROUCH_ORIG, delta * 15) #uncrouch
	if agent.direction == Vector3.ZERO: #check if not moving then calls idle state
		dispatch(&"state_ended")

	
