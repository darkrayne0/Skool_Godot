extends ConditionLeaf


func tick(actor, _blackboard):
	if actor.exists_in_game():
		return SUCCESS
	return FAILURE
