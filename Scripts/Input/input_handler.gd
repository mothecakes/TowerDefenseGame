extends Node

@export var action : ActionController 

func _process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction:
		action.move_to(direction)
	