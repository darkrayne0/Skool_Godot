extends LimboState

@onready var player_0: CharacterBody3D = $"../.."
@onready var p_state: LimboHSM = $".."
@onready var cam: Node3D = $"../../player_0_camh"



func _enter() -> void: #runs once when calling the move state
	pass


func _update(delta: float): #runs every frame after _enter finishes
	cam.position.y = lerp(cam.position.y, player_0.CROUCH_ORIG, delta * 15) #uncrouch
	if player_0.direction == Vector3.ZERO: #check if not moving then calls idle state
		p_state.dispatch(&"state_ended")
