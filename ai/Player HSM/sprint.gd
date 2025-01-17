extends LimboState

@onready var player_0: CharacterBody3D = $"../.."
@onready var p_state: LimboHSM = $".."
@onready var cam: Node3D = $"../../player_0_camh"


func _enter() -> void: #runs once when calling the sprint state
	player_0.move_speed = player_0.SPRINT #changes the normal speed to sprint speed


func _update(delta: float): #runs every frame after _enter finishes
	cam.position.y = lerp(cam.position.y, player_0.CROUCH_ORIG, delta * 15) #uncrouch
	var velocity_clamped = clamp(player_0.velocity.length(), 0.5, player_0.SPRINT * 2) #fov stuff
	var target_fov = player_0.base_fov + player_0.FOV_CHANGE * velocity_clamped #fov stuff
	player_0.camera.fov = lerp(player_0.camera.fov, target_fov, delta * 8.0) #fov stuff
	if Input.is_action_just_released("sprint"):
		p_state.dispatch(&"state_ended")
