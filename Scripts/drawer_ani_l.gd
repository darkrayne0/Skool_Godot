extends StaticBody3D


var toggle = false
var interactable = true

@onready var drawer_l: MeshInstance3D = $".."

@export var animation_player: AnimationPlayer


func interact():
	#if drawer_l.is_in_group("locked_door"):  #todo - locked drawers
		#animation_player.play("drawer_locked")

	#elif drawer_l.is_in_group("unlock_ani"):
		#if interactable == true:
			#interactable = false
			#toggle = !toggle
			#if toggle == true:
				#animation_player.play("door_unlock")
				#drawer_l.remove_from_group("unlock_ani")
			#await get_tree().create_timer(1.0, false).timeout
			#interactable = true

	if interactable:
		interactable = false
		toggle = !toggle
		if toggle:
			animation_player.play("open_l_drawer")
		else:
			animation_player.play_backwards("open_l_drawer")
		await get_tree().create_timer(0.5, false).timeout
		interactable = true


#todo - auto close door after a peroid of time
