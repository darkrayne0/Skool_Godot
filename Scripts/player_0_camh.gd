extends Node3D

@export var vertical_sens = 6
@export var horizontal_sens = 6


func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #locks mouse to the game screen

#Camera up and down bound to the mouse
func _input(event):
	if event is InputEventMouseMotion:

		get_parent().rotation_degrees.y -= event.relative.x / 100 * horizontal_sens #left/right movement
		rotation_degrees.x -= event.relative.y / 100 * vertical_sens #up/down movement
		rotation_degrees.x = clamp(rotation_degrees.x, -80, 65) #limits up/down movement
