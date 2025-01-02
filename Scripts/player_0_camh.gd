extends Node3D



func _input(event):
	if event is InputEventMouseMotion:
		rotate_x(deg_to_rad(event.relative.y * -0.04))



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
