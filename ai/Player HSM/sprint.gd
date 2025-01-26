extends LimboState

#agent = the character we are controlling
@onready var cam: Node3D = $"../../player_0_camh"


func _enter() -> void: #runs once when calling the sprint state
	pass


func _update(delta: float): #runs every frame after _enter finishes
	#handle the movement/deceleration
	agent.velocity.x = move_toward(agent.velocity.x, agent.direction.x * agent.SPRINT, delta * 12.0)
	agent.velocity.z = move_toward(agent.velocity.z, agent.direction.z * agent.SPRINT, delta * 12.0)

	cam.position.y = lerp(cam.position.y, agent.CROUCH_ORIG, delta * 15) #uncrouch
	var velocity_clamped = clamp(agent.velocity.length(), 0.5, agent.SPRINT * 2) #fov stuff
	var target_fov = agent.base_fov + agent.FOV_CHANGE * velocity_clamped #fov stuff
	agent.camera.fov = lerp(agent.camera.fov, target_fov, delta * 8.0) #fov stuff
	if Input.is_action_just_released("sprint"):
		dispatch(&"state_ended")
