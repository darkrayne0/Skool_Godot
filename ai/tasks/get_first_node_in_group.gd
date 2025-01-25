@tool
extends BTAction


@export var group: StringName #group you want type in the inspector
@export var target_node: StringName = &"target_pos" #sets/gets target node leave default in the inspector


#makes LimboAI window make more sense (renames things in the tree view)
func _generate_name() -> String:
	return "Get First Node In Group \"%s\" ➜ %s" % [group, LimboUtility.decorate_var(target_node)]


func _tick(_delta: float) -> Status:
	var nodes: Array[Node] = agent.get_tree().get_nodes_in_group(group) #get nodes in a group
	if nodes.size() == 0: # if the group contains 0 nodes
		return FAILURE
	blackboard.set_var(target_node, nodes[0]) # Stores the first node in the selected group
	return SUCCESS
