extends Node3D

@export var map_path1: EditorFileDialog
@onready var current_map: Node3D = $NorthRoom

func _unhandled_input(event):
	if event.is_action_pressed("devswitch"): #ui_cancle = esc to quit game
		print(current_map)
		swap_scene()
		print(current_map)

func swap_scene():
	var new_map

	if (current_map.name == &"NorthRoom"):
		new_map = load("res://Scenes/north_room_2.tscn")
	else:
		new_map = load("res://Scenes/north_room_1.tscn")

	remove_child(current_map)
	current_map = new_map.instantiate()
	add_child(current_map)
