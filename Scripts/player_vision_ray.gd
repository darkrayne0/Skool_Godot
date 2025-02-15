extends ShapeCast3D

#allows interacting with interactables, doors, keys etc
func _process(_delta):
	if is_colliding():
		var hitObj = get_collider(0)
		if hitObj.has_method("interact") && Input.is_action_just_pressed("interact"):
			hitObj.interact()
