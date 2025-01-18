extends StaticBody3D

var toggle = false
var interactable = true

@onready var door = $"../.."

@export var animation_player: AnimationPlayer

	
func interact():
		if door.is_in_group("locked_door"):
			animation_player.play("door_locked")
		
		elif door.is_in_group("unlock_ani"):
			if interactable == true:
				interactable = false
				toggle = !toggle
				if toggle == true:
					animation_player.play("door_unlock")
					door.remove_from_group("unlock_ani")
				await get_tree().create_timer(1.0, false).timeout
				interactable = true

		else:
			if interactable == true:
				interactable = false
				toggle = !toggle
				if toggle == false:
					animation_player.play("door_close")
				if toggle == true:
					animation_player.play("door_open")
				await get_tree().create_timer(1.0, false).timeout
				interactable = true


#todo - auto close door after a peroid of time
