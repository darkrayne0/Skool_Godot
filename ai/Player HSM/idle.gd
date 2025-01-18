extends LimboState

@onready var player_0: CharacterBody3D = $"../.."
@onready var cam: Node3D = $"../../player_0_camh"
@onready var stand_collision: CollisionShape3D = $"../../player_0_collision"
@onready var crouch_collision: CollisionShape3D = $"../../Crouch_Collision"


func _enter() -> void: #runs once when calling the idle state
	player_0.move_speed = player_0.SPEED
	player_0.crouched = false
	stand_collision.disabled = false
	crouch_collision.disabled = true

func _update(delta: float): #runs every frame after _enter finishes
	cam.position.y = lerp(cam.position.y, player_0.CROUCH_ORIG, delta * 15) #uncrouch
	if player_0.direction != Vector3.ZERO: #checks if you are moving then call moving state
		dispatch(&"move_ready")
