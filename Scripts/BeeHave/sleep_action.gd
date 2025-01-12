extends Leaf


func tick(actor, _blackboard):
	actor.chase_player(1)
	return RUNNING
