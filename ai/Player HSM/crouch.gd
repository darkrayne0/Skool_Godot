extends LimboState

@onready var player_0: CharacterBody3D = $"../.."
@onready var p_state: LimboHSM = $".."
@onready var cam: Node3D = $"../../player_0_camh"
@onready var stand_collision: CollisionShape3D = $"../../player_0_collision"
@onready var crouch_collision: CollisionShape3D = $"../../Crouch_Collision"
@onready var crouch_check: RayCast3D = $"../../player_0_camh/crouch_check"


func _enter() -> void: #runs once when calling the crouch state
	player_0.move_speed = player_0.CROUCH #changes the normal speed to sprint speed
	player_0.crouched = true
	stand_collision.disabled = true
	crouch_collision.disabled = false
	
	
func _update(delta: float): #runs every frame after _enter finishes
	if player_0.is_on_floor():
		cam.position.y = lerp(cam.position.y, player_0.CROUCH_DEPTH, delta * 15) #crouch
	if Input.is_action_just_released("crouch"):
		player_0.crouched = false
	if !player_0.crouched and !crouch_check.is_colliding():
		p_state.dispatch(&"state_ended")
