extends CharacterBody3D


const SPEED = 5.0
const JUMP = 4.5
const SPRINT = 8.0
@export var move_speed = 5.0


#looks for input
func _input(event):
	if event.is_action_pressed("ui_cancel"): #ui_cancle = esc to quit game
		get_tree().quit()
		
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta #get_gravity shorter than the alternative

	# Handle jump ui_accept = space checks to see if player is on the floor
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = JUMP
	if Input.is_action_just_pressed("sprint"): #sprint button
		move_speed = SPRINT #changes the normal speed to sprint speed
	if Input.is_action_just_released("sprint"):
		move_speed = SPEED	#changes the sprint speed to normal speed
	# Get the input direction and handle the movement/deceleration.
	# ui_actions replaced with custom input
	var input_dir := Input.get_vector("a", "d", "w", "s")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)
	
	#print(input_dir) #prints 0,0 based on direction 

	move_and_slide()#calls movement function?
