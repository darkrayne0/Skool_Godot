extends ActionLeaf

func tick(actor, _blackboard):
	actor.chase_player()
	return RUNNING
