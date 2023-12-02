class_name StateMachine
extends Node

@export var state: State

func _ready():
	change_state(state)
	
func change_state(new_state: State):
	if state is State:
		state.on_exit()
		new_state.on_enter()
		state = new_state
