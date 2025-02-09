extends Node3D


@export_file("*.tscn") var load_me: String

@export var group_name: String
@export var replace_me: String

@export_enum(
	"remove",
	"free",
	"hide") var what_to_do: String


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		RoomManager.swap_scene(load_me, replace_me, group_name ,what_to_do) #see room_manager script
	#queue_free()
