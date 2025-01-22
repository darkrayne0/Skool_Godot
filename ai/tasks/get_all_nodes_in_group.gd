@tool
extends BTAction


@export var group: StringName #group you want type in the inspector
@export var index_var: StringName = &"index" #inital int value find saved "index_var" from the blackboard in the inspector (must have variable in blackboard as int)
@export var target_node: StringName = &"target_pos" #sets/gets target node leave default in the inspector


#makes LimboAI window make more sense (renames things in the tree view)
func _generate_name() -> String:
	return "Get All Nodes In Group \"%s\"  ➜%s" % [group, LimboUtility.decorate_var(target_node)]


func _tick(_delta: float) -> Status:
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group) #get nodes in a group
	var index: = blackboard.get_var(index_var) as int #gets index_var from the blackboard
	if nodes.size() == 0: # if the group contains 0 nodes
		return FAILURE
	blackboard.set_var(target_node, nodes[index]) # Stores the first node in the selected group
	index += 1 #changes the waypoint array index to the next marker3d
	if index > nodes.size() -1: #checks if the next array index is greater than (8 currently) and sets back to 0
		index = 0
	blackboard.set_var(index_var, index) #stores index back into the blackboard
	return SUCCESS
