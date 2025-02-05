extends Node3D


@export var room_to_load: String

@export_enum(
	"NorthRoom",
	"SouthRoom",
	"EastRoom",
	"WestHall",
	"SouthEastHall",
	"NorthHall") var room_to_replace: String

@export_enum(
	"remove",
	"free",
	"hide") var what_to_do: String


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		RoomManager.swap_scene(room_to_load, room_to_replace, what_to_do) #see room_manager script
	#get_child(0).queue_free()
