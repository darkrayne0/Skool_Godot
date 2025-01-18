extends LimboState

@onready var player_0: CharacterBody3D = $"../.."
@onready var cam: Node3D = $"../../player_0_camh"


func _enter() -> void:  #runs once when calling the jump state
	print(get_root())
	if !player_0.crouched:
		player_0.velocity.y = player_0.JUMP


func _update(delta: float): #runs every frame after _enter finishes
	cam.position.y = lerp(cam.position.y, player_0.CROUCH_ORIG, delta * 15) #uncrouch
	if player_0.is_on_floor():
		dispatch(&"state_ended")
