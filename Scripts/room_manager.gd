extends Node


var _what_to_do: String
var _load_progress: Timer
var _load_me: String
var _group: Node3D
var _to_replace: Node3D
var _new_node: Node3D


func _load_monitor() -> void:

	var _load_status = ResourceLoader.load_threaded_get_status(_load_me)

	match _load_status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			print_debug("THREAD_LOAD_INVALID_RESOURCE") #print
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			print(_load_status) #print
		ResourceLoader.THREAD_LOAD_FAILED:
			print_debug("THREAD_LOAD_FAILED") #print
		ResourceLoader.THREAD_LOAD_LOADED:
			print(_load_status) #print
			_load_progress.stop()
			_load_progress.queue_free()
			_new_node = ResourceLoader.load_threaded_get(_load_me).instantiate()
			_load_finish()


func _begin_load(load_me: String) -> void:

	if (ResourceLoader.has_cached(load_me)):
		_new_node = ResourceLoader.load_threaded_get(load_me).instantiate()
	else:
		ResourceLoader.load_threaded_request(load_me, "", true) #threaded loader to load new scene
		_load_progress = Timer.new()
		_load_progress.wait_time = 0.1
		_load_progress.timeout.connect(_load_monitor)
		get_tree().root.add_child(_load_progress)
		_load_progress.start()


func _get_nodes(findroom: String, groupname: String) -> void:

	_group = get_tree().get_first_node_in_group(groupname)
	var nodes = _group.get_children() #gets all child nodes in the map node

	for node in nodes: #finds the node that matches the passed stringname
		if node.name == findroom:
			_to_replace = node #sets that node as the room to replace
			return


func _load_finish() -> void:

	if _what_to_do == "remove":
		_group.remove_child(_to_replace) #removes old node from tree, stil in memory
	elif _what_to_do == "free":
		_to_replace.free() #remove old node from tree, no longer in memory
	elif _what_to_do == "hide":
		_to_replace.hide() #Hides old node, still running and in memory

	_group.call_deferred("add_child", _new_node) #adds new node


func swap_scene(load_me: String, replace_me: String, groupname, what_to_do: String) -> void:

	_what_to_do = what_to_do #todo - maybe have a chek for all variables and comment what all this is after expansion
	_load_me = load_me

	if groupname and replace_me != null:
		_get_nodes(replace_me, groupname)
	else:
		print_debug("replace_me and/or groupname = null") #print

	if load_me != null:
		_begin_load(load_me)
	else:
		print_debug("load_me = null") #print
