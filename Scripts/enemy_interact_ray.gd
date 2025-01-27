extends RayCast3D

#allows interacting with interactables, doors, keys etc
func _process(_delta):
	if is_colliding():
		var hitObj = get_collider()
		if hitObj.has_method("interact"):
			hitObj.interact()
