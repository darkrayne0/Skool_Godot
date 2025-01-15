extends Node3D

var toggle = false
var interactable = true


func interact():

		if interactable == true:
			interactable = false

			for node in get_tree().get_nodes_in_group("locked_door"):
				if node.is_in_group("red_key_door"):
					node.remove_from_group("locked_door")
		queue_free()
