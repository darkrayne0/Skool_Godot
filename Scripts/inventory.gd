extends Control

@export var keys_carousel: Node3D
@export var notes_carousel: Node3D

var test: Array[Node3D]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		keys_carousel.rotate_carousel(-30)
	if event.is_action_pressed("right"):
		keys_carousel.rotate_carousel(30)


func _on_item_list_item_clicked(index: int, _at_position: Vector2, _mouse_button_index: int) -> void:

	match index:
		0:
			keys_carousel.show()
			notes_carousel.hide()
		1:
			keys_carousel.hide()
			notes_carousel.show()
		2:
			pass
		3:
			get_tree().quit()
