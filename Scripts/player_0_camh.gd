extends Node3D

@export var vertical_sens = -0.06
@export var horizontal_sens = -0.06


func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #locks mouse to the game screen

#Camera up and down bound to the mouse
func _input(event):
	if event is InputEventMouseMotion:
		get_parent().rotate_y(deg_to_rad(event.relative.x * horizontal_sens)) #left/right
#		get_parent().rotate_y(-event.relative.x * 0.004) #another way to do up/down
		rotate_x(deg_to_rad(event.relative.y * vertical_sens)) #up/down
#		rotate_x(-event.relative.y * 0.004) #another way to do up/down 
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(65)) #limits up/down movement
