extends ActionLeaf

func tick(actor, _blackboard):
	actor.wait_player()
	return RUNNING
