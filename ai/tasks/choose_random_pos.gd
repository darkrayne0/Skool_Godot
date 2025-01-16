extends BTAction

@export var range_min: float = 40.0
@export var range_max: float = 100.0
@export var position: StringName = &"pos"
@export var direction: StringName = &"direction"



func _tick(_delta: float) -> Status:
	var pos: Vector3
	var dir = rand
	
	
	return SUCCESS
