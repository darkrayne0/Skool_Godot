extends Node3D

@export var vertical_sens := 6.0
@export var horizontal_sens := 6.0
const CROUCH_DEPTH := -0.5

func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #locks mouse to the game screen
	elif event.is_action_pressed("lose_focus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) #temp - unlocks mouse likely just for testing? maybe for final game too
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion: #Camera up and down bound to the mouse
			get_parent().rotation_degrees.y -= event.relative.x / 100 * horizontal_sens #left/right movement
			rotation_degrees.x -= event.relative.y / 100 * vertical_sens #up/down movement
			rotation_degrees.x = clamp(rotation_degrees.x, -80, 65) #limits up/down movement
