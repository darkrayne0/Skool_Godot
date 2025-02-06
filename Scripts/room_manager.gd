extends Node

var _map: Node3D
var _room_to_replace: Node3D
var _new_room: Node3D



func _get_rooms(findroom: String) -> void:
	_map = get_tree().get_first_node_in_group("map")
	var rooms = _map.get_children() #gets all child nodes in the map node

	for room in rooms: #finds the node that matches the passed stringname
		if room.name == findroom:
			_room_to_replace = room #sets that node as the room to replace


func swap_scene(room_to_load: String, room_to_replace: String, what_to_do: String) -> void:
	_get_rooms(room_to_replace)

	ResourceLoader.load_threaded_request(room_to_load) #threaded loader to load new scene
	await get_tree().create_timer(1.0).timeout #todo - current wait time for new scene to load
	_new_room = ResourceLoader.load_threaded_get(room_to_load).instantiate() #inserts loaded scene

	if what_to_do == "remove":
		_map.remove_child(_room_to_replace) #removes old node from tree, stil in memory
	elif what_to_do == "free":
		_room_to_replace.free() #remove old node from tree, no longer in memory
	elif what_to_do == "hide":
		_room_to_replace.hide() #Hides old node, still running and in memory

	_map.add_child(_new_room) #adds new scene to tree
	#_map.call_deferred("add_child", _new_room) #same as above, maybe better?

func load_room():
	pass
