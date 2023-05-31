extends Node
class_name CharacterStateMachine

var states : Array[State]
@export var current_state : State
@export var animation_tree :AnimationTree
@export var character : CharacterBody2D

# Called when the node enters the scene tree for the first time.

func _physics_process(delta):
	if(current_state.next_state != null):
		switch_states(current_state.next_state)
		
	current_state.state_process(delta)

func check_if_can_move():
	return current_state.can_move

func switch_states(new_state : State):
	if (current_state != null):
		current_state.on_exit()
		current_state.next_state = null
	current_state = new_state
	current_state.on_enter()

func _input(event : InputEvent):
	current_state.state_input(event)
